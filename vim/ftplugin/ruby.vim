" Rails
let g:rails_projections = {
      \ "app/workers/*_worker.rb": {
      \   "command": "worker",
      \   "template":
      \     ["class {camelcase|capitalize|colons}Worker",
      \      "  include Sidekiq::Worker", "", "  def perform(id)",
      \      "  end", "end"]
      \ },
      \ "app/services/*_service.rb": {
      \   "command": "service",
      \   "template":
      \     ["class {camelcase|capitalize|colons}Service", "end"],
      \   "affinity": "model"
      \ },
      \ "app/managers/*_manager.rb": {
      \   "command": "manager",
      \   "template":
      \     ["module {camelcase|capitalize|colons}Manager",
      \      "  extend self", "", "end"],
      \   "affinity": "model"
      \ },
      \ "app/serializers/*_serializer.rb": {
      \   "command": "serializer",
      \   "template":
      \     ["class {camelcase|capitalize|colons}Serializer < ActiveModel::Serializer",
      \       "end"]
      \ },
      \ "spec/factories/*_factory.rb": {
      \   "command": "factory",
      \   "template":
      \     ["FactoryGirl.define do",
      \      "  factory :{} do",
      \      "  end", "end"],
      \   "affinity": "model"
      \ }}

" RuboCop
"
if !exists('*FormatRuby()')
  function! FormatRuby()
    silent write!
    echo "Formatting..."
    call system("rubocop --auto-correct " . expand('%'))
    silent edit!
    write
    redraw!
  endfunction

  nnoremap <buffer> + :call FormatRuby()<CR>
endif
