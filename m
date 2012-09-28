From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH scsi] Add NULL checking of return value from
 scsi_cmd_to_driver()
Date: Fri, 28 Sep 2012 08:48:18 +0100
Message-ID: <1348818498.2411.8.camel@dabdike.int.hansenpartnership.com>
References: <1348464626.2475.13.camel@ThinkPad-T420>
	 <1348465493.2467.3.camel@dabdike> <1348470210.2475.47.camel@ThinkPad-T420>
	 <1348472104.2467.8.camel@dabdike> <yq13924b4uw.fsf@sermon.lab.mkp.net>
	 <1348721055.2509.0.camel@dabdike> <yq1bogr8itb.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1bogr8itb.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-09-27 at 13:41 -0400, Martin K. Petersen wrote:
> >>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> 
> >> I'm fine with having the eh action be triggered for FS requests only,
> >> if that's what you're asking?
> 
> James> Sort of ... I was thinking do it for all non REQ_TYPE_BLOCK_PC
> James> commands (which includes flush and other strange types), but if
> James> you think it should only be for REQ_TYPE_FS, that's fine too.
> 
> I'm ok either way.

OK, let's mirror the code in scsi.c then, so != REQ_TYPE_BLOCK_PC.

James
