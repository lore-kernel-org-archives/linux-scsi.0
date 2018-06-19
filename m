From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: cxlflash: Change return type for fault handler
Date: Tue, 19 Jun 2018 09:11:38 -0500
Message-ID: <1E0C8AFA-5168-4916-932E-8E1C3F0EADE6@linux.vnet.ibm.com>
References: <20180611194204.GA18687@jordon-HP-15-Notebook-PC>
 <20180613232347.GA3851@p8tul1-build.aus.stglabs.ibm.com>
 <CAFqt6zb-fDRdH1_k7QwW_YEErKYPYFNpJFrK7N82P0PLiKnRtA@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.4 \(3445.8.2\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFqt6zb-fDRdH1_k7QwW_YEErKYPYFNpJFrK7N82P0PLiKnRtA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Matthew Wilcox <willy@infradead.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, Sabyasachi Gupta <sabyasachi.linux@gmail.com>, brajeswar.linux@gmail.com
List-Id: linux-scsi@vger.kernel.org



> On Jun 19, 2018, at 12:10 AM, Souptick Joarder <jrdr.linux@gmail.com> wrote:
> 
> On Thu, Jun 14, 2018 at 4:53 AM, Matthew R. Ochs
> <mrochs@linux.vnet.ibm.com> wrote:
>> On Tue, Jun 12, 2018 at 01:12:04AM +0530, Souptick Joarder wrote:
>>> Use new return type vm_fault_t for fault handler. For
>>> now, this is just documenting that the function returns
>>> a VM_FAULT value rather than an errno. Once all instances
>>> are converted, vm_fault_t will become a distinct type.
>>> 
>>> Ref-> commit 1c8f422059ae ("mm: change return type to vm_fault_t")
>>> 
>>> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
>> 
>> This looks fine to me.
>> 
>> FYI that there is another handler for this driver in a series
>> destined for 4.18 and currently in next/master.
>> 
>> Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
>> 
> 
> Matthew, is this patch queued for 4.19 ?
> 
Below is the commit that added fault handler in ocxl. It is in 4.18 rc1 (upstream/master tree)

commit 93b8f8df552c5a30bfddb75a632f1b2a436c2cae
    scsi: cxlflash: Support adapter context mmap and release
