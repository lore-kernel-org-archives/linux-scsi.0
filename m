From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 3/3] target: Return descriptor format sense data
Date: Tue, 14 Jul 2015 06:34:44 -0700
Message-ID: <55A50FF4.7060100@sandisk.com>
References: <1436697423-20611-1-git-send-email-sagig@mellanox.com> <1436697423-20611-4-git-send-email-sagig@mellanox.com> <20150714071703.GC31117@infradead.org> <yq1r3obrvyn.fsf@sermon.lab.mkp.net> <55A4F9B7.905@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <55A4F9B7.905@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>
Cc: Sagi Grimberg <sagig@mellanox.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

On 07/14/15 04:59, Sagi Grimberg wrote:
> +#define TARGET_SENSE_DESC_FORMAT(dev)          \
> +       dev->transport->get_blocks(dev) >= 0xffffffffULL

 From SPC-5: "4.4.4 Returning a value in the INFORMATION field in the 
sense data. To return a value less than or equal to FFFF_FFFFh in the 
INFORMATION field: [ ... ]". I think this means the value FFFF_FFFFh is 
allowed in fixed format sense data.

Bart.
