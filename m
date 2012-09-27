From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH scsi] Add NULL checking of return value from scsi_cmd_to_driver()
Date: Wed, 26 Sep 2012 22:02:15 -0400
Message-ID: <yq13924b4uw.fsf@sermon.lab.mkp.net>
References: <1348464626.2475.13.camel@ThinkPad-T420>
	<1348465493.2467.3.camel@dabdike>
	<1348470210.2475.47.camel@ThinkPad-T420>
	<1348472104.2467.8.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1348472104.2467.8.camel@dabdike> (James Bottomley's message of
	"Mon, 24 Sep 2012 11:35:04 +0400")
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

James> Plus, I think it fixes a bug where you get different behaviours
James> from REQ_TYPE_BLOCK_PC commands when a driver is and isn't
James> attached (I've cc'd Martin to see what he thinks).

I'm fine with having the eh action be triggered for FS requests only, if
that's what you're asking?

-- 
Martin K. Petersen	Oracle Linux Engineering
