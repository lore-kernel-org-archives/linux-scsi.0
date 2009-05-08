From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCHSET] block,scsi,libata: implement alt_size
Date: Fri, 08 May 2009 12:21:45 -0400
Message-ID: <4A045C19.4060801@garzik.org>
References: <1233456951-992-1-git-send-email-tj@kernel.org>	
	<49F902CF.7080307@garzik.org> <49F903DD.8040707@kernel.org>	
	<49FA0349.3090706@garzik.org>	
	<e9c3a7c20904301415t621670a0l1bd64c7d74d369f@mail.gmail.com>	
	<49FEA127.1000905@kernel.org>	
	<e9c3a7c20905040948m572e23dj1aa197dbd20ff037@mail.gmail.com>	
	<49FFB275.7000507@kernel.org>
	<e9c3a7c20905050834t79a1c03dt83df288b2f38ed76@mail.gmail.com>
	<4A03F7A8.9090204@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A03F7A8.9090204@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tejun Heo <tj@kernel.org>
Cc: linux-scsi@vger.kernel.org, Mauelshagen@redhat.com, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com
List-Id: linux-scsi@vger.kernel.org

Tejun Heo wrote:
> Dan Williams wrote:
>> On Mon, May 4, 2009 at 8:28 PM, Tejun Heo <tj@kernel.org> wrote:
>>> Pushing this in the kernel without updating dm-raid is kind of
>>> pointless.  Who should I be poking to get the userland part moving?
>> Dmraid is not the only potential user.  Mdadm will also care about
>> this as I have seen a report that points to a user having what looks
>> like an HPA issue with an Intel(R) Matrix array.  So, there are two
>> immediate users for this interface.  Heinz is the right person to poke
>> for dmraid updates.  I'll handle the mdadm update.
> 
> Alright, then.  With Jeff's reluctant ack and scheduled mdadm update,
> I guess this one can go upstream.  I'll refresh the patchset and
> repost.  Umm... BTW do I have Heinz's mail address right?

The email addr is correct according to dmraid-current.tar.bz2 (dated Sep 
2008), at least.  I don't have any better info.

	Jeff
