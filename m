From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v1.3 1/11] arcmsr: Revise interrupt service routine to
 fix command timeout
Date: Thu, 20 Feb 2014 15:14:35 +0300
Message-ID: <20140220121435.GY26776@mwanda>
References: <CAKiknE9pf-hQOTcxbw8WnHECDJDZMHJA-TBEPeg7+q5nb+AoCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKiknE9pf-hQOTcxbw8WnHECDJDZMHJA-TBEPeg7+q5nb+AoCA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?utf-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
Cc: jejb@kernel.com, jbottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, fengguang.wu@intel.com, Tomas Henzl <thenzl@redhat.com>, =?utf-8?B?5ZCz56Kn5ra8?= <billion.wu@areca.com.tw>
List-Id: linux-scsi@vger.kernel.org

On Thu, Feb 20, 2014 at 08:05:05PM +0800, =E9=BB=83=E6=B8=85=E9=9A=86 w=
rote:
> From: Ching <ching2048@areca.com.tw>
>=20
> Rewrite interrupt service routine to fix command timeout on controlle=
r too
> heavy loading.
>=20
> Singed-off-by: Ching <ching2048@areca.com.tw>

Your email client screwed up the whitespace completely.  Read
Documentation/email-clients.txt or use `git send-email`
http://www.freedesktop.org/wiki/Software/PulseAudio/HowToUseGitSendEmai=
l/

There are also many unrelated white space changes in this patch.

regards,
dan carpenter
