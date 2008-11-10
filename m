From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [osd-dev] [PATCH 04/18] libosd: OSDv1 preliminary implementation
Date: Sun, 09 Nov 2008 21:37:30 -0800
Message-ID: <4917C89A.70909@oracle.com>
References: <491073BB.4000900@panasas.com>	<1225817069-5969-1-git-send-email-bharrosh@panasas.com>	<20081104180347.GA9818@uranus.ravnborg.org> <49119BAF.6040603@panasas.com> <4916F9F5.9040409@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753516AbYKJFi6@vger.kernel.org>
In-Reply-To: <4916F9F5.9040409@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, open-osd development <osd-dev@open-osd.org>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, Sami.Iren@seagate.com, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Randy Dunlap <randy.dunlap@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Boaz Harrosh wrote:
> Boaz Harrosh wrote:
>> Sam Ravnborg wrote:
>>>> +EXPORT_SYMBOL(osd_dev_init);
>>> kernel-doc comments for all exported funtions / variables.
>>>
>> I have some kernel-doc comments of exported functions in the Header
>> file. I have not yet finished all of them. (Laziness on my part).
>>
>> Are kernel-doc comments in headers a big NO-NO. I like it this way,
>> so when I have to learn a new Library all the information
>> I need to know is in the header. Also the header is a much better place
>> when you do programing by shopping, that is you don't know what you need
>> and you look for what's available.
>>
>> Thanks
>> Boaz
> 
> Sam please comment if kernel-doc comments are OK in headers

Hi,

The de facto standard for kernel-doc comments is at the implementation site,
which means normally in .c files, except for macros or inline functions.

Sure you can find some exceptions to that.  And there is no hard requirement
in Documentation/kernel-doc-nano-HOWTO.txt.

IMO the biggest concern is making sure that the (kernel-doc) comments are
updated when the function implementation changes (if updates are needed).
Where would be the best place for this to be more likely to happen?
Usually at the function implementation, I would say.

~Randy


-- 
~Randy
