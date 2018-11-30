From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH RFC 00/15] Zero ****s, hugload of hugs <3
Date: Fri, 30 Nov 2018 11:27:09 -0800
Message-ID: <20181130192737.15053-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: linux-kernel@vger.kernel.org
Cc: "open list:MIPS" <linux-mips@linux-mips.org>, Geert Uytterhoeven <geert+renesas@glider.be>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "open list:DRM DRIVER FOR NVIDIA GEFORCE/QUADRO GPUS" <nouveau@lists.freedesktop.org>, Amir Goldstein <amir73il@gmail.com>, "open list:DRM DRIVER FOR NVIDIA GEFORCE/QUADRO GPUS" <dri-devel@lists.freedesktop.org>, "open list:IDE SUBSYSTEM" <linux-ide@vger.kernel.org>, Eric Dumazet <edumazet@google.com>, "open list:MEMORY TECHNOLOGY DEVICES MTD" <linux-mtd@lists.infradead.org>, Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>, Zhu Yanjun <yanjun.zhu@oracle.com>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, Helge Deller <deller@gmx.de>, "Steven Rostedt (VMware)" <rostedt@goodmis.org>, Federico Vaga <federico.vaga@vaga.pv.it>, Yonghong Song <yhs@fb.com>, Paolo Abeni <pabeni@redhat.>
List-Id: linux-scsi@vger.kernel.org

SW4gb3JkZXIgdG8gY29tcGx5IHdpdGggdGhlIENvQywgcmVwbGFjZSAqKioqIHdpdGggYSBodWcu
CgpKYXJra28gU2Fra2luZW4gKDE1KToKICBNSVBTOiByZXBsYWNlICoqKiogd2l0aCBhIGh1Zwog
IERvY3VtZW50YXRpb246IHJlcGxhY2UgKioqKiB3aXRoIGEgaHVnCiAgZHJtL25vdXZlYXU6IHJl
cGxhY2UgKioqKiB3aXRoIGEgaHVnCiAgbTY4azogcmVwbGFjZSAqKioqIHdpdGggYSBodWcKICBw
YXJpc2M6IHJlcGxhY2UgKioqKiB3aXRoIGEgaHVnCiAgY3B1ZnJlcTogcmVwbGFjZSAqKioqIHdp
dGggYSBodWcKICBpZGU6IHJlcGxhY2UgKioqKiB3aXRoIGEgaHVnCiAgbWVkaWE6IHJlcGxhY2Ug
KioqKiB3aXRoIGEgaHVnCiAgbXRkOiByZXBsYWNlICoqKiogd2l0aCBhIGh1ZwogIG5ldC9zdW5o
bWU6IHJlcGxhY2UgKioqKiB3aXRoIGEgaHVnCiAgc2NzaTogcmVwbGFjZSAqKioqIHdpdGggYSBo
dWcKICBpbm90aWZ5OiByZXBsYWNlICoqKiogd2l0aCBhIGh1ZwogIGlycTogcmVwbGFjZSAqKioq
IHdpdGggYSBodWcKICBsaWI6IHJlcGxhY2UgKioqKiB3aXRoIGEgaHVnCiAgbmV0OiByZXBsYWNl
ICoqKiogd2l0aCBhIGh1ZwoKIERvY3VtZW50YXRpb24va2VybmVsLWhhY2tpbmcvbG9ja2luZy5y
c3QgICAgICB8ICAyICstCiBhcmNoL202OGsvaW5jbHVkZS9hc20vc3VuM2ludHMuaCAgICAgICAg
ICAgICAgfCAgMiArLQogYXJjaC9taXBzL3BjaS9vcHMtYnJpZGdlLmMgICAgICAgICAgICAgICAg
ICAgIHwgMjQgKysrKysrKysrLS0tLS0tLS0tLQogYXJjaC9taXBzL3NnaS1pcDIyL2lwMjItc2V0
dXAuYyAgICAgICAgICAgICAgIHwgIDIgKy0KIGFyY2gvcGFyaXNjL2tlcm5lbC9zeXNfcGFyaXNj
LmMgICAgICAgICAgICAgICB8ICAyICstCiBkcml2ZXJzL2NwdWZyZXEvcG93ZXJub3ctazcuYyAg
ICAgICAgICAgICAgICAgfCAgMiArLQogLi4uL2dwdS9kcm0vbm91dmVhdS9udmttL3N1YmRldi9i
aW9zL2luaXQuYyAgIHwgIDIgKy0KIC4uLi9ub3V2ZWF1L252a20vc3ViZGV2L3BtdS9mdWMvbWFj
cm9zLmZ1YyAgICB8ICAyICstCiBkcml2ZXJzL2lkZS9jbWQ2NDAuYyAgICAgICAgICAgICAgICAg
ICAgICAgICAgfCAgMiArLQogZHJpdmVycy9tZWRpYS9pMmMvYnQ4MTkuYyAgICAgICAgICAgICAg
ICAgICAgIHwgIDggKysrKy0tLQogZHJpdmVycy9tdGQvbXRkX2Jsa2RldnMuYyAgICAgICAgICAg
ICAgICAgICAgIHwgIDIgKy0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L3N1bi9zdW5obWUuYyAgICAg
ICAgICAgICB8ICA0ICsrLS0KIGRyaXZlcnMvc2NzaS9xbG9naWNwdGkuaCAgICAgICAgICAgICAg
ICAgICAgICB8ICAyICstCiBmcy9ub3RpZnkvaW5vdGlmeS9pbm90aWZ5X3VzZXIuYyAgICAgICAg
ICAgICAgfCAgMiArLQoga2VybmVsL2lycS90aW1pbmdzLmMgICAgICAgICAgICAgICAgICAgICAg
ICAgIHwgIDIgKy0KIGxpYi92c3ByaW50Zi5jICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICB8ICAyICstCiBuZXQvY29yZS9za2J1ZmYuYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
fCAgMiArLQogMTcgZmlsZXMgY2hhbmdlZCwgMzMgaW5zZXJ0aW9ucygrKSwgMzEgZGVsZXRpb25z
KC0pCgotLSAKMi4xOS4xCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZlbEBsaXN0cy5mcmVlZGVza3Rv
cC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9kcmkt
ZGV2ZWwK
