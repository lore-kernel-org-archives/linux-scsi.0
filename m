From: "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [trivial PATCH V2] treewide: Align function definition open/close
 braces
Date: Wed, 21 Mar 2018 23:36:49 +0100
Message-ID: <CAJZ5v0hYKnPVxbbBY-SDjxBY2Pj12WD3nD9zE--+eZpBzZr-NA@mail.gmail.com>
References: <5ccbbf083e26bddfb4ea4f819ed62347ce266f39.1521669820.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <5ccbbf083e26bddfb4ea4f819ed62347ce266f39.1521669820.git.joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: "open list:NETWORKING DRIVERS (WIRELESS)" <linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexandre Belloni <alexandre.belloni-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, the arch/x86 maintainers <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Xiubo Li <Xiubo.Lee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Timur Tabi <timur-N01EOCouUvQ@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Liam Girdwood <lgirdwood-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Adaptec OEM Raid Solutions <aacraid-ugMvIWC9OiRBDgjK7y7TUQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, ACPI Devel Maling List <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rtc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David (ChunMing) Zhou" <David1.Zhou-5C7GfCeVMHo@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, "open list:TARGET SUBSYSTEM" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Dept-GELinuxNIC
List-Id: linux-scsi@vger.kernel.org

T24gV2VkLCBNYXIgMjEsIDIwMTggYXQgMTE6MDkgUE0sIEpvZSBQZXJjaGVzIDxqb2VAcGVyY2hl
cy5jb20+IHdyb3RlOgo+IFNvbWUgZnVuY3Rpb25zIGRlZmluaXRpb25zIGhhdmUgZWl0aGVyIHRo
ZSBpbml0aWFsIG9wZW4gYnJhY2UgYW5kL29yCj4gdGhlIGNsb3NpbmcgYnJhY2Ugb3V0c2lkZSBv
ZiBjb2x1bW4gMS4KPgo+IE1vdmUgdGhvc2UgYnJhY2VzIHRvIGNvbHVtbiAxLgo+Cj4gVGhpcyBh
bGxvd3MgdmFyaW91cyBmdW5jdGlvbiBhbmFseXplcnMgbGlrZSBnbnUgY29tcGxleGl0eSB0byB3
b3JrCj4gcHJvcGVybHkgZm9yIHRoZXNlIG1vZGlmaWVkIGZ1bmN0aW9ucy4KPgo+IFNpZ25lZC1v
ZmYtYnk6IEpvZSBQZXJjaGVzIDxqb2VAcGVyY2hlcy5jb20+Cj4gQWNrZWQtYnk6IEFuZHkgU2hl
dmNoZW5rbyA8YW5keS5zaGV2Y2hlbmtvQGdtYWlsLmNvbT4KPiBBY2tlZC1ieTogUGF1bCBNb29y
ZSA8cGF1bEBwYXVsLW1vb3JlLmNvbT4KPiBBY2tlZC1ieTogQWxleCBEZXVjaGVyIDxhbGV4YW5k
ZXIuZGV1Y2hlckBhbWQuY29tPgo+IEFja2VkLWJ5OiBEYXZlIENoaW5uZXIgPGRjaGlubmVyQHJl
ZGhhdC5jb20+Cj4gUmV2aWV3ZWQtYnk6IERhcnJpY2sgSi4gV29uZyA8ZGFycmljay53b25nQG9y
YWNsZS5jb20+Cj4gQWNrZWQtYnk6IEFsZXhhbmRyZSBCZWxsb25pIDxhbGV4YW5kcmUuYmVsbG9u
aUBmcmVlLWVsZWN0cm9ucy5jb20+Cj4gQWNrZWQtYnk6IE1hcnRpbiBLLiBQZXRlcnNlbiA8bWFy
dGluLnBldGVyc2VuQG9yYWNsZS5jb20+Cj4gQWNrZWQtYnk6IFRha2FzaGkgSXdhaSA8dGl3YWlA
c3VzZS5kZT4KPiBBY2tlZC1ieTogTWF1cm8gQ2FydmFsaG8gQ2hlaGFiIDxtY2hlaGFiQHMtb3Bl
bnNvdXJjZS5jb20+Cj4gLS0tCj4KPiBnaXQgZGlmZiAtdyBzdGlsbCBzaG93cyBubyBkaWZmZXJl
bmNlLgo+Cj4gVGhpcyBwYXRjaCB3YXMgc2VudCBidXQgRGVjZW1iZXIgYW5kIG5vdCBhcHBsaWVk
Lgo+Cj4gQXMgdGhlIHRyaXZpYWwgbWFpbnRhaW5lciBzZWVtcyBub3QgYWN0aXZlLCBpdCdkIGJl
IG5pY2UgaWYKPiBBbmRyZXcgTW9ydG9uIHBpY2tzIHRoaXMgdXAuCj4KPiBWMjogUmVtb3ZlIGZz
L3hmcy9saWJ4ZnMveGZzX2FsbG9jLmMgYXMgaXQncyB1cGRhdGVkIGFuZCByZW1lcmdlIHRoZSBy
ZXN0Cj4KPiAgYXJjaC94ODYvaW5jbHVkZS9hc20vYXRvbWljNjRfMzIuaCAgICAgICAgICAgICAg
ICAgICB8ICAyICstCj4gIGRyaXZlcnMvYWNwaS9jdXN0b21fbWV0aG9kLmMgICAgICAgICAgICAg
ICAgICAgICAgICAgfCAgMiArLQo+ICBkcml2ZXJzL2FjcGkvZmFuLmMgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHwgIDIgKy0KCkZvciB0aGUgQUNQSSBjaGFuZ2VzOgoKQWNrZWQt
Ynk6IFJhZmFlbCBKLiBXeXNvY2tpIDxyYWZhZWwuai53eXNvY2tpQGludGVsLmNvbT4KX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KYW1kLWdmeCBtYWlsaW5n
IGxpc3QKYW1kLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVz
a3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9hbWQtZ2Z4Cg==
