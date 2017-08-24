From: James Smart <jsmart2021@gmail.com>
Subject: Re: [PATCH v2] scsi: lpfc: avoid false positive gcc-8 warning
Date: Thu, 24 Aug 2017 09:28:33 -0700
Message-ID: <59c13631-2586-5aa8-4bc1-fdc416bc2dc5@gmail.com>
References: <20170824003440.4270-1-jsmart2021@gmail.com>
 <CAK8P3a39cW5mC8qAKhpuMTcYjroRStv9z9yaiH3jTvb9wK34-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a39cW5mC8qAKhpuMTcYjroRStv9z9yaiH3jTvb9wK34-g@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, James Smart <james.smart@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On 8/24/2017 4:01 AM, Arnd Bergmann wrote:
> 
> I have also come up with a different workaround of my own
> (sorry for the broken formatting here) and tested it successfully
> over night. I have definitely spent more time on it than it was
> worth now. Let me know if you prefer that version over yours,
> then I'll submit that as a proper patch with your Ack.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> --- a/drivers/scsi/lpfc/lpfc_debugfs.h

I'm ok with either solution. I prefer less change but this is a trivial 
thing.

Signed-off-by: James Smart <james.smart@broadcom.com>

-- james
