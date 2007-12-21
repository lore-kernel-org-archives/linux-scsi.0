From: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: INITIO scsi driver fails to work properly
Date: Fri, 21 Dec 2007 14:30:58 -0500
Message-ID: <476C1472.1040103@redhat.com>
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>	 <20071217031841.f483e5ac.akpm@linux-foundation.org>	 <9f00bd9d0712170341u7fef1fc9pc9986dda1a0475cb@mail.gmail.com>	 <47666904.8060605@panasas.com> <9f00bd9d0712190048g60d79ma067ba85b5553459@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755528AbXLUTbf@vger.kernel.org>
In-Reply-To: <9f00bd9d0712190048g60d79ma067ba85b5553459@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Filippos Papadopoulos <psybases@gmail.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/19/2007 03:48 AM, Filippos Papadopoulos wrote:
> On Dec 17, 2007 2:18 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
>> I have found one problem. Please try patch [2] below and report.
>> If it still fails try to enable debugging by setting with patch [1]
>> these values at top of drivers/scsi/initio.c. And send dmsgs.
>>
>> Boaz
>>
> 
> 
> I tried patch[2] (addition of   sg++)  at 2.6.24-rc5-mm1 but the
> system hangs after some seconds when the initio driver loads.
> I will try patch[1] next week to see what happens.
> 
> Would it be better to open a bug report at bugzilla?
> 

There is also a Fedora bug report against 2.6.23. The user has
applied commit e9e42faf47255274a1ed0b9bf1c46118023ec5fa from
2.6.24-rc plus the two additional fixes under discussion and it
hangs for him too.

https://bugzilla.redhat.com/show_bug.cgi?id=390531
