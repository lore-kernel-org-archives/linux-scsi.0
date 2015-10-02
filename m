From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v5 05/34] cxlflash: Fix data corruption when vLUN used
 over multiple cards
Date: Fri, 2 Oct 2015 15:03:54 +0200
Message-ID: <560E80BA.90906@redhat.com>
References: <1443714773-9176-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1443714908-13176-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1443714908-13176-1-git-send-email-mrochs@linux.vnet.ibm.com>
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

T24gMS4xMC4yMDE1IDE3OjU1LCBNYXR0aGV3IFIuIE9jaHMgd3JvdGU6Cj4gSWYgdGhlIHNhbWUg
dmlydHVhbCBMVU4gaXMgYWNjZXNzZWQgb3ZlciBtdWx0aXBsZSBjYXJkcywgb25seSBhY2Nlc3Nl
cwo+IG1hZGUgb3ZlciB0aGUgZmlyc3QgY2FyZCB3aWxsIGJlIHZhbGlkLiBBY2Nlc3NlcyBtYWRl
IG92ZXIgdGhlIHNlY29uZAo+IGNhcmQgd2lsbCBnbyB0byB0aGUgd3JvbmcgTFVOIGNhdXNpbmcg
ZGF0YSBjb3JydXB0aW9uLgo+Cj4gVGhpcyBpcyBiZWNhdXNlIHRoZSBnbG9iYWwgTFVOJ3MgbW9k
ZSB3b3JkIHdhcyBiZWluZyB1c2VkIHRvIGRldGVybWluZQo+IHdoZXRoZXIgdGhlIExVTiB0YWJs
ZSBmb3IgdGhhdCBjYXJkIG5lZWRzIHRvIGJlIHByb2dyYW1tZWQuIFRoZSBtb2RlCj4gd29yZCB3
b3VsZCBiZSBzZXR1cCBieSB0aGUgZmlyc3QgY2FyZCwgY2F1c2luZyB0aGUgTFVOIHRhYmxlIGZv
ciB0aGUKPiBzZWNvbmQgY2FyZCB0byBub3QgYmUgcHJvZ3JhbW1lZC4KPgo+IEJ5IHVuY29uZGl0
aW9uYWxseSBpbml0aWFsaXppbmcgdGhlIExVTiB0YWJsZSAobm90IGRlcGVuZGluZyBvbiB0aGUK
PiBtb2RlIHdvcmQpLCB0aGUgcHJvYmxlbSBpcyBhdm9pZGVkLgo+Cj4gU2lnbmVkLW9mZi1ieTog
TWF0dGhldyBSLiBPY2hzIDxtcm9jaHNAbGludXgudm5ldC5pYm0uY29tPgo+IFNpZ25lZC1vZmYt
Ynk6IE1hbm9qIE4uIEt1bWFyIDxtYW5vakBsaW51eC52bmV0LmlibS5jb20+Cj4gUmV2aWV3ZWQt
Ynk6IEJyaWFuIEtpbmcgPGJya2luZ0BsaW51eC52bmV0LmlibS5jb20+CgpSZXZpZXdlZC1ieTog
VG9tYXMgSGVuemwgPHRoZW56bEByZWRoYXQuY29tPgoKVG9tYXMKCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4cHBjLWRldiBtYWlsaW5nIGxpc3QK
TGludXhwcGMtZGV2QGxpc3RzLm96bGFicy5vcmcKaHR0cHM6Ly9saXN0cy5vemxhYnMub3JnL2xp
c3RpbmZvL2xpbnV4cHBjLWRldg==
