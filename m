From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH resend 1/5] libata-scsi: minor cleanup in ata_mselect_*()
Date: Thu, 21 Jul 2016 21:45:59 +0300
Message-ID: <c604e92f-9bcd-da2c-8d78-2a678c81b05f@cogentembedded.com>
References: <af84a796696f2f366d330595d1a818e8daeb86d8.1469126217.git.tom.ty89@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <af84a796696f2f366d330595d1a818e8daeb86d8.1469126217.git.tom.ty89@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tom.ty89@gmail.com, tj@kernel.org, hare@suse.de, arnd@arndb.de
Cc: sfr@canb.auug.org.au, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello.

On 07/21/2016 09:41 PM, tom.ty89@gmail.com wrote:

> From: Tom Yan <tom.ty89@gmail.com>
>
> 1. Removed a repeated bit masking in ata_mselect_control()
> 2. Moved `wce`/`d_sense` assignment below the page validity checks
> 3. Added/Removed empty lines where appropriate
>
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>

    Perhaps Tejun is OK with that, but if you ask me doing 1 task per patch is 
a better practice.

[...]

MBR, Sergei
