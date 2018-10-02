From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v4 1/6] mpt3sas: Introduce
 mpt3sas_base_pci_device_is_available
Date: Tue, 2 Oct 2018 09:04:43 -0500
Message-ID: <20181002140443.GA120535@bhelgaas-glaptop.roam.corp.google.com>
References: <1537935759-14754-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1537935759-14754-2-git-send-email-suganath-prabu.subramani@broadcom.com>
 <20180926213241.GI28024@bhelgaas-glaptop.roam.corp.google.com>
 <20180927070327.wvl5glb4c7gtjoa3@wunner.de>
 <20180927184746.GM28024@bhelgaas-glaptop.roam.corp.google.com>
 <20180927190959.dio4qwti3i4accjm@wunner.de>
 <CA+RiK64EdoSngTzDMUP4xXNcZQa6KfyucsRw42+DUo3s+JPmVQ@mail.gmail.com>
 <20181001204051.GD142872@bhelgaas-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181001204051.GD142872@bhelgaas-glaptop.roam.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: lukas@wunner.de, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, Andy Shevchenko <andy.shevchenko@gmail.com>, Sathya Prakash <Sathya.Prakash@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, linux-kernel@vger.kernel.org, benh@kernel.crashing.org, ruscur@russell.cc, sbobroff@linux.ibm.com, oohall@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 01, 2018 at 03:40:51PM -0500, Bjorn Helgaas wrote:
> I think the names "pci_device_is_present()" and
> "mpt3sas_base_pci_device_is_available()" contribute to the problem
> because they make promises that can't be kept -- all we can say is
> that the device *was* present, but we know whether it is *still*
> present.

Oops, I meant "we DON'T know whether it is still present."

> I think it would be better if the interfaces were something
> like "pci_device_is_absent()" because that gives a result we can rely
> on.  If that returns true, we know the device is definitely gone.
> 
> Bjorn
