From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFC PATCH 1/4] convert block layer drivers to
	blkerr error values
Date: Wed, 24 Aug 2005 15:32:46 -0400
Message-ID: <430CCB5E.3090808@pobox.com>
References: <1124874238.10888.18.camel@max> <20050824192132.GA20663@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050824192132.GA20663@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Christie <michaelc@cs.wisc.edu>, axboe@suse.de
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, Patrick Mansfield <patmans@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

In general, I'm a bit worried about these changes, for two overall reasons:

1) I didn't see any analysis of the ultimate end users of block layer 
error values:  the filesystems.

2) This begins to converge with the SCSI layer's error/retry/etc. error 
values.  Since I would eventually like to see SCSI's non-SCSI-related 
infrastructure "moved up", a bit -more- alignment with SCSI at this 
stage might be nice.

	Jeff
