From: <Kento.A.Kobayashi@sony.com>
Subject: RE: [PATCH] usb: uas: fix usb subsystem hang after power off hub
 port
Date: Tue, 16 Apr 2019 02:31:57 +0000
Message-ID: <AE5419EAB4965843B3C0C1FE29F1FFE58A9BEA@JPYOKXMS103.jp.sony.com>
References: <Pine.LNX.4.44L0.1904151107350.1575-100000@iolanthe.rowland.org>
 <Pine.LNX.4.44L0.1904151129550.1575-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1904151129550.1575-100000@iolanthe.rowland.org>
Content-Language: ja-JP
Sender: linux-kernel-owner@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: bvanassche@acm.org, martin.petersen@oracle.com, jejb@linux.ibm.com, oneukum@suse.com, gregkh@linuxfoundation.org, usb-storage@lists.one-eyed-alien.net, Jacky.Cao@sony.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

>On Mon, 15 Apr 2019, Alan Stern wrote:
>
>> On Mon, 15 Apr 2019 Kento.A.Kobayashi@sony.com wrote:
>> 
>> > Hi
>> > 
>> > >The unbind happens from inside the SCSI EH callback.  If that really is not allowed, we'll need to change it.  Or we can just change it regardless, since the effort required is pretty small.
>> > >
>> > >Kento, please try the patch below.  Does it help with your problem?
>> > 
>> > Thank you for suggestion about this problem.
>> > I confirmed your patch fixes this problem.
>> 
>> Good; I will submit it.

Thank you for allowing submit about fixing this problem.

>
>I forgot to ask: Is it okay to add
>
>	Tested-by: Kento Kobayashi <Kento.A.Kobayashi@sony.com>
>
>along with the patch?

Sure.
In addition, if you can, could you please add member who contribute to this problem fixing?
Cao, Jacky <Jacky.Cao@sony.com>

Regards,
Kento Kobayashi
