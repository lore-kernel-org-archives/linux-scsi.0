From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH resend 1/5] libata-scsi: minor cleanup in ata_mselect_*()
Date: Fri, 22 Jul 2016 02:51:02 +0800
Message-ID: <CAGnHSEnA6JW8joA2dozaqY+hVdN8fjajtpznfSo8j4DwFiE5yw@mail.gmail.com>
References: <af84a796696f2f366d330595d1a818e8daeb86d8.1469126217.git.tom.ty89@gmail.com>
 <c604e92f-9bcd-da2c-8d78-2a678c81b05f@cogentembedded.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c604e92f-9bcd-da2c-8d78-2a678c81b05f@cogentembedded.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.de>, Arnd Bergmann <arnd@arndb.de>, sfr@canb.auug.org.au, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch should cause no behavioral change. Even the (removal of)
the redundant bit mask should be a nop. So it seems like a bit of an
overkill to split them.

On 22 July 2016 at 02:45, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> Hello.
>
> On 07/21/2016 09:41 PM, tom.ty89@gmail.com wrote:
>
>> From: Tom Yan <tom.ty89@gmail.com>
>>
>> 1. Removed a repeated bit masking in ata_mselect_control()
>> 2. Moved `wce`/`d_sense` assignment below the page validity checks
>> 3. Added/Removed empty lines where appropriate
>>
>> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
>
>
>    Perhaps Tejun is OK with that, but if you ask me doing 1 task per patch
> is a better practice.
>
> [...]
>
> MBR, Sergei
>
