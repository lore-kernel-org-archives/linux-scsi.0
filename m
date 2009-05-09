From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/3] scsi: add scsi_device->alt_capacity
Date: Sun, 10 May 2009 01:09:08 +0900
Message-ID: <4A05AAA4.9010806@kernel.org>
References: <1241828002-12742-1-git-send-email-tj@kernel.org>	
	<1241828002-12742-3-git-send-email-tj@kernel.org>
	<1241842999.6357.2.camel@mulgrave>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1241842999.6357.2.camel@mulgrave>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: jeff@garzik.org, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, Mauelshagen@redhat.com
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> This is done at slightly the wrong level.  Capacity is actually a
> property of struct scsi_disk not struct scsi_device ... shouldn't
> alt_capacity be at the same level?

Hmmm... I think that was my first try and then I moved it to sdev for
some reason I can't rememer now.  I'll look into it again and try to
move it into sdev.

Thanks.

-- 
tejun
