From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Mon, 15 Nov 2010 23:36:50 +0300
Message-ID: <4CE199E2.5030106@vlnb.net>
References: <4CD8566D.1020202@vlnb.net> <20101109002829.GA22633@kroah.com> <4CD9A9B8.70708@vlnb.net> <4CDA6CD4.3010308@panasas.com> <4CDAFE6E.7050200@vlnb.net> <4CDBBE80.40908@panasas.com> <4CDC56F9.9040601@vlnb.net> <20101112012315.GE17097@core.coreip.homeip.net> <4CDEC8D2.8080101@vlnb.net> <20101113235938.GA1827@kroah.com> <20101115065919.GB14442@core.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101115065919.GB14442@core.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg KH <greg@kroah.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Dmitry Torokhov, on 11/15/2010 09:59 AM wrote:
> On Sat, Nov 13, 2010 at 03:59:38PM -0800, Greg KH wrote:
>> On Sat, Nov 13, 2010 at 08:20:18PM +0300, Vladislav Bolkhovitin wrote:
>>> So, I decided to reimplement it to be completely synchronous. SYSFS
>>> authors did really great job and thanks to the excellent internal SYSFS
>>> design and implementation it is absolutely safe. See:
>>>
>>> [root@tgt ~]# modprobe scst
>>> [root@tgt ~]# cd /sys/kernel/scst_tgt/
>>
>> Sorry, but no, you can't put this in /sys/kernel/ without getting the
>> approval of the sysfs maintainer.
>>
>> I really don't understand why you are using kobjects in the first place,
>> why isn't this in the main device tree in the kernel, using 'struct
>> device'?
> 
> It is my understanding that Vlad is able to reflect the topology by
> manipulating sysfs objects there.

Correct. As I wrote in the previous e-mail, SCST doesn't deal with
devices, so doesn't have a need to use struct device.

>> In the end, I guess it really doesn't matter as this code isn't getting
>> merged so I shouldn't worry about it, right?
>>
> 
> This is quite unfortunate as I still have not seen the public comparison
> of the 2 implementations and the lists of benefits and shortfalls for
> both of them.

Indeed, it is unfortunate :(. Undercover political games continue...

Vlad
