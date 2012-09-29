From: Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [PATCH 1/3] Revert "ata: make ata port as parent device of scsi
 host"
Date: Sat, 29 Sep 2012 19:08:19 +0200
Message-ID: <50672B03.8000101@mvista.com>
References: <1348772644-12486-1-git-send-email-gwendal@google.com> <1348772644-12486-2-git-send-email-gwendal@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1348772644-12486-2-git-send-email-gwendal@google.com>
Sender: linux-ide-owner@vger.kernel.org
To: Gwendal Grignou <gwendal@google.com>
Cc: aaron.lu@intel.com, minggr@gmail.com, tj@kernel.org, jgarzik@pobox.com, james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello.

On 27-09-2012 21:04, Gwendal Grignou wrote:

> This reverts commit 9a6d6a2ddabbd32c07f6a38b659e5f3db319fa5a.
>
> Instead, melt libata transport sysfs object in scsi objects.
>
> Change-Id: I8c709f63ddf7ba97b9e6f449d5c0b8b85e44e818

    Remove this line please, it has no place in the upstream commit.

> Signed-off-by: Gwendal Grignou<gwendal@google.com>
>

MBR, Sergei

