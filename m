From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: tmscsim broken on amd64 with 2.6.5?
Date: Mon, 12 Apr 2004 13:11:10 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0404121301110.2267-200000@poirot.grange>
References: <200404111120.17574.info@roessner-net.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-1228362866-1081768169=:2267"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.net ([213.165.64.20]:14055 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S262862AbUDLLMP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Apr 2004 07:12:15 -0400
In-Reply-To: <200404111120.17574.info@roessner-net.com>
Content-ID: <Pine.LNX.4.44.0404121310070.2267@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Christian Roessner <info@roessner-net.com>
Cc: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---1463811839-1228362866-1081768169=:2267
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <Pine.LNX.4.44.0404121310071.2267@poirot.grange>

Hi

Can you try the attached patch, please. If it still doesn't work, could
you add something like
kern.*                          -/var/log/tmscsim.log
to your /etc/syslog.conf, do killall -HUP syslogd, and send me the log
starting from insertion of the module. Also a
lspci -vvxxx -s 0000:01:07.0
(I hope the syntax is correct for your platform).

Thanks
Guennadi
---
Guennadi Liakhovetski


---1463811839-1228362866-1081768169=:2267
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; NAME="tmscsim-ulong-io_port.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44.0404121309290.2267@poirot.grange>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME="tmscsim-ulong-io_port.patch"

LS0tIGxpbnV4LTIuNi4zLmhhcmRsaW5rL2RyaXZlcnMvc2NzaS90bXNjc2lt

LmN+CVNhdCBBcHIgMTAgMjM6MDg6MTUgMjAwNA0KKysrIGxpbnV4LTIuNi4z

LmhhcmRsaW5rL2RyaXZlcnMvc2NzaS90bXNjc2ltLmMJTW9uIEFwciAxMiAx

MzowMDowOCAyMDA0DQpAQCAtMjIyOCw3ICsyMjI4LDcgQEANCiB7DQogICAg

IFBERVZERUNMMDsNCiAgICAgVUNIQVIgICBpcnE7DQotICAgIFVJTlQgICAg

aW9fcG9ydDsNCisgICAgVUxPTkcgICBpb19wb3J0Ow0KIA0KICAgICAvL2Rj

MzkwX3BTSFRfc3RhcnQgPSBwc2h0Ow0KICAgICBkYzM5MF9wQUNCX3N0YXJ0

ID0gTlVMTDsNCg==
---1463811839-1228362866-1081768169=:2267--
