From: Avri Altman <Avri.Altman-Sjgp3cTcYWE@public.gmane.org>
Subject: RE: [PATCH v1 0/2] scsi: ufs: Fix broken hba->outstanding_tasks
Date: Sun, 21 Jul 2019 12:52:47 +0000
Message-ID: <SN6PR04MB4925BD03422B827F76A5F7E5FCC50@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <1562906656-27154-1-git-send-email-stanley.chu@mediatek.com>
 <SN6PR04MB4925208835D4760249E82DB7FCC50@SN6PR04MB4925.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <SN6PR04MB4925208835D4760249E82DB7FCC50-UKdxhu0+N/VnT3GYGerMaFM8qxBPnqtHvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org" <alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, "pedrom.sousa-HKixBCOQz3hWk0Htik3J/w@public.gmane.org" <pedrom.sousa-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Cc: "marc.w.gonzalez-GANU6spQydw@public.gmane.org" <marc.w.gonzalez-GANU6spQydw@public.gmane.org>, "andy.teng-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org" <andy.teng-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "chun-hung.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org" <chun-hung.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org" <kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "evgreen-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <evgreen-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org" <peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "beanhuo-AL4WhLSQfzjQT0dZR+AlfA@public.gmane.org" <beanhuo-AL4WhLSQfzjQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

PiANCj4gSGksDQo+IA0KPiA+DQo+ID4gQ3VycmVudGx5IGJpdHMgaW4gaGJhLT5vdXRzdGFuZGlu
Z190YXNrcyBhcmUgY2xlYXJlZCBvbmx5IGFmdGVyIHRoZWlyDQo+ID4gY29ycmVzcG9uZGluZyB0
YXNrIG1hbmFnZW1lbnQgY29tbWFuZHMgYXJlIHN1Y2Nlc3NmdWxseSBkb25lIGJ5DQo+ID4gX191
ZnNoY2RfaXNzdWVfdG1fY21kKCkuDQo+ID4NCj4gPiBJZiB0aW1lb3V0IGhhcHBlbnMgaW4gYSB0
YXNrIG1hbmFnZW1lbnQgY29tbWFuZCwgaXRzIGNvcnJlc3BvbmRpbmcNCj4gPiBiaXQgaW4gaGJh
LT5vdXRzdGFuZGluZ190YXNrcyB3aWxsIG5vdCBiZSBjbGVhcmVkIHVudGlsIG5leHQgdGFzaw0K
PiA+IG1hbmFnZW1lbnQgY29tbWFuZCB3aXRoIHRoZSBzYW1lIHRhZyB1c2VkIHN1Y2Nlc3NmdWxs
eSBmaW5pc2hlcy7igKcNCj4gdWZzaGNkX2NsZWFyX3RtX2NtZCBpcyBhbHNvIGNhbGxlZCBhcyBw
YXJ0IG9mIHVmc2hjZF9lcnJfaGFuZGxlci4NCj4gRG9lcyB0aGlzIGNoYW5nZSBzb21ldGhpbmcg
aW4geW91ciBhc3N1bXB0aW9ucz8NCkFuZCBCVFcgdGhlcmUgaXMgYSBzcGVjaWZpYyBfX2NsZWFy
X2JpdCBpbiBfX3Vmc2hjZF9pc3N1ZV90bV9jbWQoKSBpbiBjYXNlIG9mIGEgVE8uDQoNCj4gDQo+
IFRoYW5rcywNCj4gQXZyaQ0KPiANCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCkxpbnV4LW1lZGlhdGVrIG1haWxpbmcgbGlzdApMaW51eC1tZWRpYXRla0Bs
aXN0cy5pbmZyYWRlYWQub3JnCmh0dHA6Ly9saXN0cy5pbmZyYWRlYWQub3JnL21haWxtYW4vbGlz
dGluZm8vbGludXgtbWVkaWF0ZWsK
