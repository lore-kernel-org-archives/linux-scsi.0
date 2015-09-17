From: Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: [Bugfix 3/3] eata: Enhance eata driver to support PCI device
 hot-removal
Date: Thu, 17 Sep 2015 14:49:36 +0800
Message-ID: <55FA6280.3050000@linux.intel.com>
References: <CAErSpo4oignSpK-LCLO=deW_FZ-V58GUhBxJ5uvmXe4DYo4WdA@mail.gmail.com>
 <1442200140-30808-1-git-send-email-jiang.liu@linux.intel.com>
 <1442200140-30808-4-git-send-email-jiang.liu@linux.intel.com>
 <55F6837A.5020807@suse.de> <20150916134211.GA21535@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150916134211.GA21535@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>, Arthur Marsh <arthur.marsh@internode.on.net>, Dario Ballabio <ballabio_dario@emc.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2015/9/16 21:42, Christoph Hellwig wrote:
> On Mon, Sep 14, 2015 at 10:21:14AM +0200, Hannes Reinecke wrote:
>> Welll ... if you don't have hardware (and I strongly hope you refer to
>> 'hardware able to do hotplugging', not 'hardware for the eata driver'
>> ...) why add the code at all?
>> Chances are no-one will ever need eata PCI hotplug; SCSI parallel
>> typically isn't very good at hotplugging, so throwing in PCI hotplug
>> will only confuse matters more.
>> Plus due to the sheer mechanics involved here I find it very unlikely
>> anyone will be using it in real life.
> 
> Because it's used for module removal and we want every driver to use
> the standard interface that.
> 
> Jiang, you also need to convert the driver to
> scsi_add_host/scsi_remove_host from the legacy scsi_register interface,
> otherwise the SCSI layer will be very unhappy.
> 
> Take a look at commit 0d31f8759109cbc1e6fc196d08e6b0e8a9e93b3f for
> example, the change should be straight forward.
Hi Christoph,
	I have taken a look at the commit 0d31f8759109cb and it seems
that the conversion is not so big. But I have no hardware for testing,
so could only ask for help from community.
Thanks!
Gerry
