From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] target: Add WRITE_VERIFY_16 Support
Date: Fri, 27 Jan 2017 20:56:03 +0000
Message-ID: <1485550543.4267.27.camel@sandisk.com>
References: <1485550152-18623-1-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1485550152-18623-1-git-send-email-bryantly@linux.vnet.ibm.com>
Content-Language: en-US
Content-ID: <F3B3CE0195BFF54FA83A61C44B8AC7E2@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: "bryantly@linux.vnet.ibm.com" <bryantly@linux.vnet.ibm.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "mikecyr@linux.vnet.ibm.com" <mikecyr@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2017-01-27 at 14:49 -0600, Bryant G. Ly wrote:
> For clients who want to utilize more than 2GB you need
> WRITE AND VERIFY 16 support.

Hello Bryant,

This patch introduces a bug for WRITE AND VERIFY(16) parsing that already
exists for WRITE AND VERIFY(10) parsing, namely that the value of the BYTCH=
K
field is ignored. Is it OK for you to wait a few weeks with adding WRITE AN=
D
VERIFY(16) support and to come back to this after I have posted my WRITE AN=
D
VERIFY(10) fix?

Bart.=
