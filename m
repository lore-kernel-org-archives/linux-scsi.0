From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v5 06/34] cxlflash: Fix to avoid sizeof(bool)
Date: Fri, 2 Oct 2015 15:06:30 +0200
Message-ID: <560E8156.7010709@redhat.com>
References: <1443714773-9176-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1443714915-14960-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1443714915-14960-1-git-send-email-mrochs@linux.vnet.ibm.com>
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
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

T24gMS4xMC4yMDE1IDE3OjU1LCBNYXR0aGV3IFIuIE9jaHMgd3JvdGU6Cj4gVXNpbmcgc2l6ZW9m
KGJvb2wpIGlzIGNvbnNpZGVyZWQgcG9vciBmb3JtIGZvciB2YXJpb3VzIHJlYXNvbnMgYW5kCj4g
c3BhcnNlIHdhcm5zIHVzIG9mIHRoYXQuIENvcnJlY3QgYnkgY2hhbmdpbmcgdHlwZSBmcm9tIGJv
b2wgdG8gdTguCj4KPiBTaWduZWQtb2ZmLWJ5OiBNYXR0aGV3IFIuIE9jaHMgPG1yb2Noc0BsaW51
eC52bmV0LmlibS5jb20+Cj4gU2lnbmVkLW9mZi1ieTogTWFub2ogTi4gS3VtYXIgPG1hbm9qQGxp
bnV4LnZuZXQuaWJtLmNvbT4KPiBSZXZpZXdlZC1ieTogQnJpYW4gS2luZyA8YnJraW5nQGxpbnV4
LnZuZXQuaWJtLmNvbT4KPiBSZXZpZXdlZC1ieTogRGFuaWVsIEF4dGVucyA8ZGphQGF4dGVucy5u
ZXQ+CgpSZXZpZXdlZC1ieTogVG9tYXMgSGVuemwgPHRoZW56bEByZWRoYXQuY29tPgoKVG9tYXMK
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4cHBj
LWRldiBtYWlsaW5nIGxpc3QKTGludXhwcGMtZGV2QGxpc3RzLm96bGFicy5vcmcKaHR0cHM6Ly9s
aXN0cy5vemxhYnMub3JnL2xpc3RpbmZvL2xpbnV4cHBjLWRldg==
