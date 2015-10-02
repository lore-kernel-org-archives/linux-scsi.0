From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v5 07/34] cxlflash: Fix context encode mask width
Date: Fri, 2 Oct 2015 15:07:09 +0200
Message-ID: <560E817D.3010508@redhat.com>
References: <1443714773-9176-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1443714920-15500-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1443714920-15500-1-git-send-email-mrochs@linux.vnet.ibm.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

T24gMS4xMC4yMDE1IDE3OjU1LCBNYXR0aGV3IFIuIE9jaHMgd3JvdGU6Cj4gVGhlIGNvbnRleHQg
ZW5jb2RlIG1hc2sgY292ZXJzIG1vcmUgdGhhbiAzMi1iaXRzLCBtYWtpbmcgaXQKPiBhIGxvbmcg
aW50ZWdlci4gVGhpcyBzaG91bGQgYmUgbm90ZWQgYnkgYXBwZW5kaW5nIHRoZSBVTEwKPiB3aWR0
aCBzdWZmaXggdG8gdGhlIG1hc2suCj4KPiBTaWduZWQtb2ZmLWJ5OiBNYXR0aGV3IFIuIE9jaHMg
PG1yb2Noc0BsaW51eC52bmV0LmlibS5jb20+Cj4gU2lnbmVkLW9mZi1ieTogTWFub2ogTi4gS3Vt
YXIgPG1hbm9qQGxpbnV4LnZuZXQuaWJtLmNvbT4KPiBSZXZpZXdlZC1ieTogQnJpYW4gS2luZyA8
YnJraW5nQGxpbnV4LnZuZXQuaWJtLmNvbT4KPiBSZXZpZXdlZC1ieTogRGFuaWVsIEF4dGVucyA8
ZGphQGF4dGVucy5uZXQ+CgpSZXZpZXdlZC1ieTogVG9tYXMgSGVuemwgPHRoZW56bEByZWRoYXQu
Y29tPgoKVG9tYXMKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCkxpbnV4cHBjLWRldiBtYWlsaW5nIGxpc3QKTGludXhwcGMtZGV2QGxpc3RzLm96bGFicy5v
cmcKaHR0cHM6Ly9saXN0cy5vemxhYnMub3JnL2xpc3RpbmZvL2xpbnV4cHBjLWRldg==
