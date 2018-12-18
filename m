From: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/7] v4.19-stable randconfig fixes
Date: Mon, 17 Dec 2018 19:20:28 -0500
Message-ID: <20181218002028.GX2746@sasha-vm>
References: <20181214221023.3878670-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <freedreno-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20181214221023.3878670-1-arnd-r2nGTMty4D4@public.gmane.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/freedreno>,
 <mailto:freedreno-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/freedreno>
List-Post: <mailto:freedreno-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:freedreno-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/freedreno>,
 <mailto:freedreno-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: freedreno-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "Freedreno" <freedreno-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, linux-aspeed-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, David Brown <david.brown-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Daniel Drake <dsd-2X9k7bc8m7Mdnm+yROfE0A@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Frederich <jfrederich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Gross <andy.gross-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lubomir Rintel <lkundrak-NGH9Lh4a5iE@public.gmane.org>, dou_liyang-9Onoh4P/yGk@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andrew Jeffery <andrew-zrmu5oMJ5Fs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stabl
List-Id: linux-scsi@vger.kernel.org

T24gRnJpLCBEZWMgMTQsIDIwMTggYXQgMTE6MTA6MDVQTSArMDEwMCwgQXJuZCBCZXJnbWFubiB3
cm90ZToKPkhpIEdyZWcsCj4KPkkgZGlkIHNvbWUgcmFuZGNvbmZpZyB0ZXN0aW5nIG9uIGxpbnV4
LTQuMTkgYXJtL2FybTY0L3g4Ni4gU28gZmFyIEkgbmVlZGVkCj4yNyBwYXRjaGVzLCBtb3N0IG9m
IHdoaWNoIGFyZSBhbHNvIHN0aWxsIG5lZWRlZCBpbiBtYWlubGluZSBMaW51eC4gSQo+aGFkIHN1
Ym1pdHRlZCBzb21lIGJlZm9yZSwgYW5kIG90aGVycyB3ZXJlIG5vdCBzdWJtaXR0ZWQgcHJldmlv
dXNseQo+Zm9yIHNvbWUgcmVhc29uLiBJJ2xsIHRyeSB0byBnZXQgdGhvc2UgZml4ZWQgaW4gbWFp
bmxpbmUgYW5kIHRoZW4KPm1ha2Ugc3VyZSB3ZSBnZXQgdGhlbSBpbnRvIDQuMTkgYXMgd2VsbC4K
Pgo+VGhpcyBzZXJpZXMgZm9yIG5vdyBjb250YWlucyBmb3VyIHBhdGNoZXMgdGhhdCBkaWQgbWFr
ZSBpdCBpbnRvIG1haW5saW5lOgo+Cj4yZTZhZTExZGQwZDEgKCJzbGltYnVzOiBuZ2Q6IG1hcmsg
UE0gZnVuY3Rpb25zIGFzIF9fbWF5YmVfdW51c2VkIikKPjMzZjQ5NTcxZDc1MCAoInN0YWdpbmc6
IG9scGNfZGNvbjogYWRkIGEgbWlzc2luZyBkZXBlbmRlbmN5IikKPjBlZWVjMDE0ODhkYSAoInNj
c2k6IHJhaWRfYXR0cnM6IGZpeCB1bnVzZWQgdmFyaWFibGUgd2FybmluZyIpCj4xMWQ0YWZkNGZm
NjYgKCJzY2hlZC9wZWx0OiBGaXggd2FybmluZyBhbmQgY2xlYW4gdXAgSVJRIFBFTFQgY29uZmln
IikKPgo+RmVlbCBmcmVlIHRvIGVpdGhlciBjaGVycnktcGljayB0aG9zZSBmcm9tIG1haW5saW5l
IG9yIGFwcGx5IHRoZQo+cGF0Y2ggZnJvbSB0aGlzIHNlcmllcywgd2hpY2hldmVyIHdvcmtzIGJl
c3QgZm9yIHlvdS4KPgo+VGhlIG90aGVyIHRocmVlIHBhdGNoZXMgYXJlIGZvciB3YXJuaW5ncyBp
biBjb2RlIHRoYXQgZ290IHJlbW92ZWQgaW4KPm1haW5saW5lIGtlcm5lbHM6Cj4KPjNlOWVmYzMy
OTlkZCAoImkyYzogYXNwZWVkOiBIYW5kbGUgbWFzdGVyL3NsYXZlIGNvbWJpbmVkIGlycSBldmVu
dHMgcHJvcGVybHkiKQo+OTcyOTEwOTQ4ZmI2ICgiQVJNOiBkdHM6IHFjb206IFJlbW92ZSBBcnJv
dyBTRDYwMCBldmFsIGJvYXJkIikKPmVmZmVjODc0NzkyZiAoImRybS9tc20vZHB1OiBSZW1vdmUg
ZHB1X2RiZyIpCj4KPk15IGZlZWxpbmcgd2FzIHRoYXQgaXQncyBzYWZlciB0byBqdXN0IGFkZHJl
c3MgdGhlIHdhcm5pbmcgYnkgZml4aW5nCj50aGUgY29kZSBjb3JyZWN0bHkgaW4gZWFjaCBvZiB0
aGVzZSBjYXNlcywgYnV0IGlmIHlvdSBkaXNhZ3JlZSwKPmFwcGx5aW5nIHRoZSBtYWlubGluZSBj
aGFuZ2Ugc2hvdWxkIHdvcmsgZXF1YWxseSB3ZWxsLCBzbyBkZWNpZGUKPmZvciB5b3Vyc2VsZi4K
ClRoYW5rcyBBcm5kLCBJIHRvb2sgdGhlIHNlcmllcyBhcyBpcy4KCldlIHJlYWxseSBuZWVkIHRv
IGRpc2N1c3MgaG93IC1zdGFibGUgZGVhbHMgd2l0aCByZW1vdmVkIGNvZGUgdXBzdHJlYW0uCkZv
ciBzb21lIGNhc2VzLCB3ZSBzaG91bGQgcHJvYmFibHkgZm9sbG93IHN1aXQgYW5kIHJlbW92ZSBp
dCBmcm9tCi1zdGFibGUgYXMgd2VsbCAoSSdtIG1vc3RseSB0aGlua2luZyBkb2RneSBjb2RlIHdp
dGggcG90ZW50aWFsIHNlY3VyaXR5Cmlzc3VlcykuCgotLQpUaGFua3MsClNhc2hhCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkZyZWVkcmVubyBtYWlsaW5n
IGxpc3QKRnJlZWRyZW5vQGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3RzLmZyZWVk
ZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2ZyZWVkcmVubwo=
