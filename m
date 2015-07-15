From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v1 3/4] target: Return descriptor format sense data in
 case the LU spans 64bit sectors
Date: Wed, 15 Jul 2015 07:07:59 -0700
Message-ID: <55A6693F.5010807@sandisk.com>
References: <1436946939-19415-1-git-send-email-sagig@mellanox.com> <1436946939-19415-4-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1436946939-19415-4-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 07/15/15 00:55, Sagi Grimberg wrote:
> +bool target_sense_desc_format(struct se_device *dev)
> +{
> +	return dev->transport->get_blocks(dev) > 0xffffffffULL;
> +}

Please consider to use U32_MAX instead of 0xffffffffULL since that would 
make this function easier to read and to verify.

Bart.
