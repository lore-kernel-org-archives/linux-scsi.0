From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/1] RFC: scsi/dm-mpath: return -EACCES on
 reservation conflict
Date: Mon, 12 Oct 2009 23:03:29 -0500
Message-ID: <4AD3FC11.7060003@cs.wisc.edu>
References: <1255406553-7054-1-git-send-email-michaelc@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1255406553-7054-1-git-send-email-michaelc@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

michaelc@cs.wisc.edu wrote:
> So, I did another take just using lots of different -EXYZ values. See
> this patch

For got to add the link
http://www.kernel.org/pub/linux/kernel/people/mnc/multipath/dm-mpath-use-exyz.patch
> 
> for an example. The problem is still that the transport error
> and generic error cases are the same so all I bought was the handling
> of the reservation conflict.
>
