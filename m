From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCHv2 1/1] SCSI: update hosts module to use idr index
 management
Date: Tue, 6 Oct 2015 15:00:09 +0200
Message-ID: <5613C5D9.4080406@suse.com>
References: <cover.1444085255.git.lduncan@suse.com>
 <1a69690d615610c1dee725db7e6d81cf2db28266.1444085255.git.lduncan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1a69690d615610c1dee725db7e6d81cf2db28266.1444085255.git.lduncan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On 10/06/2015 01:01 AM, Lee Duncan wrote:
> Update the SCSI hosts module to use idr to manage
> its host_no index instead of an ATOMIC integer. This
> also allows using idr_find() to look up the SCSI
> host structure given the host number.
>
> This means that the SCSI host number will now
> be reclaimable.
>
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> ---
>   drivers/scsi/hosts.c | 60 +++++++++++++++++++++++++---------------------------
>   1 file changed, 29 insertions(+), 31 deletions(-)
>
Very nice.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
