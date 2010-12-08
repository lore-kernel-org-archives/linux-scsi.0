From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC v2] support SATA ODD zero power
Date: Wed, 08 Dec 2010 18:25:30 +0100
Message-ID: <4CFFBF8A.6060105@kernel.org>
References: <4D0040AC02000023000252F3@novprvlin0050.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4D0040AC02000023000252F3@novprvlin0050.provo.novell.com>
Sender: linux-ide-owner@vger.kernel.org
To: Joey Lee <jlee@novell.com>
Cc: linux-scsi@vger.kernel.org, henry.su.ati@gmail.com, James.Bottomley@suse.de, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

(cc'ing linux-ide)

Hello,

On 12/08/2010 04:36 PM, Joey Lee wrote:
> Dear all expert, 
> 
> Hi, m... I just google the SATA ODD zero power support and found Henry
> already contribute the patch:
> 
>  http://kerneltrap.org/mailarchive/linux-scsi/2010/6/25/6885558
> 
> And, after first round review, 
> The second version is here:
>  http://www.spinics.net/lists/linux-scsi/msg44925.html
> 
> But, I didn't see this patch merged in kernel maintain, does there have
> any problem with this patch? or actually the patch already in queue
> waiting to merge to mainline?
> 
> I appreciate if can have any comment to me.

IIRC, at the time, the problem was that nobody had the hardware and
the implementation was solely based on the specification only.  I
didn't want it to go in without any actual testing, so it was put on
hold for the time being.  Do you have access to a device with zsero
power support?  If so, are you willing to test the implementation?

Hmmm... at the same time, I'm a little bit doubtful about its
usefulness.  How much power does it save?  Furthermore, ODDs are often
omitted on mobile devices these days.  So, I have a slight reluctance
against including it but if the implementation is clean enough and
there is enough benefits it shouldn't be too difficult to overcome.

Thanks.

-- 
tejun
