From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH v3 1/3] Revert "scsi: core: return BLK_STS_OK for DID_OK
 in __scsi_error_from_host_byte()"
Date: Tue, 10 Apr 2018 08:49:11 -0600
Message-ID: <7d0eb778-2add-1a87-87a9-b0fb11c48372@wdc.com>
References: <20180405173301.13186-2-bart.vanassche@wdc.com>
 <DM5PR2101MB103238DFFB89F207C9459B41FBBE0@DM5PR2101MB1032.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <DM5PR2101MB103238DFFB89F207C9459B41FBBE0@DM5PR2101MB1032.namprd21.prod.outlook.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Sasha Levin <Alexander.Levin@microsoft.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, Douglas Gilbert <dgilbert@interlog.com>, Damien Le Moal <damien.lemoal@wdc.com>, Christoph Hellwig <hch@lst.de>, Lee Duncan <lduncan@suse.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 04/10/18 07:49, Sasha Levin wrote:
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: e39a97353e53 scsi: core: return BLK_STS_OK for DID_OK in __scsi_error_from_host_byte().
> 
> The bot has also determined it's probably a bug fixing patch. (score: 94.6757)
> 
> The bot has tested the following trees: v4.16.1.
> 
> v4.16.1: Build OK!

Hello Sasha,

Please fix your bot. Your bot replied to a patch that has a "Cc: stable" 
tag.

Bart.
