From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [-next] BUG_ON in scsi_target_destroy()
Date: Fri, 15 Apr 2016 16:55:55 -0400
Message-ID: <yq1inzipp5w.fsf@sermon.lab.mkp.net>
References: <20160411090146.GA537@swordfish> <2201725.I2to9GCRQJ@c203>
	<1460560474.2322.3.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1460560474.2322.3.camel@linux.vnet.ibm.com> (James Bottomley's
	message of "Wed, 13 Apr 2016 08:14:34 -0700")
Sender: linux-next-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, "Ewan D. Milne" <emilne@redhat.com>, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, linux-next@vger.kernel.org, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Xiong Zhou <jencce.kernel@gmail.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "James" == James Bottomley <jejb@linux.vnet.ibm.com> writes:

James> The STARGET_REMOVE state you added only applies to the case we're
James> trying to kill a target.  In the natural operation case, which is
James> what everyone else is running into, we will try to remove a
James> running target when it has no more scsi devices left on it.  So
James> the correct patch should be to make the BUG_ON see this:

Commit amended.

-- 
Martin K. Petersen	Oracle Linux Engineering
