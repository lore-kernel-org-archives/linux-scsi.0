From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v5 03/34] cxlflash: Fix read capacity timeout
Date: Fri, 2 Oct 2015 14:49:04 +0200
Message-ID: <560E7D40.2060508@redhat.com>
References: <1443714773-9176-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1443714897-11795-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1443714897-11795-1-git-send-email-mrochs@linux.vnet.ibm.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org>
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Manoj Kumar <kumarmn@us.ibm.com>, Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

T24gMS4xMC4yMDE1IDE3OjU0LCBNYXR0aGV3IFIuIE9jaHMgd3JvdGU6Cj4gRnJvbTogTWFub2og
S3VtYXIgPGt1bWFybW5AdXMuaWJtLmNvbT4KPgo+IFRoZSB0aW1lb3V0IHZhbHVlIGZvciByZWFk
IGNhcGFjaXR5IGlzIHRvbyBzbWFsbC4gQ2VydGFpbiBkZXZpY2VzCj4gbWF5IHRha2UgbG9uZ2Vy
IHRvIHJlc3BvbmQgYW5kIHRodXMgdGhlIGNvbW1hbmQgbWF5IHByZW1hdHVyZWx5Cj4gdGltZW91
dC4gQWRkaXRpb25hbGx5IHRoZSBsaXRlcmFsIHVzZWQgZm9yIHRoZSB0aW1lb3V0IGlzIHN0YWxl
Lgo+Cj4gVXBkYXRlIHRoZSB0aW1lb3V0IHRvIDMwIHNlY29uZHMgKG1hdGNoZXMgdGhlIHZhbHVl
IHVzZWQgaW4gc2QuYykKPiBhbmQgcmV3b3JrIHRoZSB0aW1lb3V0IGxpdGVyYWwgdG8gYSBtb3Jl
IGFwcHJvcHJpYXRlIGRlc2NyaXB0aW9uLgo+Cj4gU2lnbmVkLW9mZi1ieTogTWF0dGhldyBSLiBP
Y2hzIDxtcm9jaHNAbGludXgudm5ldC5pYm0uY29tPgo+IFNpZ25lZC1vZmYtYnk6IE1hbm9qIE4u
IEt1bWFyIDxtYW5vakBsaW51eC52bmV0LmlibS5jb20+Cj4gUmV2aWV3ZWQtYnk6IEJyaWFuIEtp
bmcgPGJya2luZ0BsaW51eC52bmV0LmlibS5jb20+CgpSZXZpZXdlZC1ieTogVG9tYXMgSGVuemwg
PHRoZW56bEByZWRoYXQuY29tPgoKVG9tYXMKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCkxpbnV4cHBjLWRldiBtYWlsaW5nIGxpc3QKTGludXhwcGMtZGV2
QGxpc3RzLm96bGFicy5vcmcKaHR0cHM6Ly9saXN0cy5vemxhYnMub3JnL2xpc3RpbmZvL2xpbnV4
cHBjLWRldg==
