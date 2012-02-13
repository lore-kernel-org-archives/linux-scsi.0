From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Pe: [PATCH v5 1/3] virtio-scsi: first version
Date: Mon, 13 Feb 2012 14:17:26 +0100
Message-ID: <4F390D66.9050706@redhat.com>
References: <4F312492.1040002@de.ibm.com> <OFAFB86CAE.9917478D-ONC125799D.004AF231-C125799D.004CE6D2@de.ibm.com> <4F313526.2050907@redhat.com> <OF36197712.1A42EB9E-ONC125799E.0049E3C2-C125799E.004AD4BF@de.ibm.com> <4F3390FB.80107@redhat.com> <1329077777.21613.60.camel@dabdike.int.hansenpartnership.com> <4F38B657.7060405@de.ibm.com> <4F38C27E.7030300@redhat.com> <1329136806.9333.383.camel@haakon2.linux-iscsi.org> <4F3907EB.4030402@redhat.com> <20120213130005.GB26773@redhat.com> <CAN05THTOY894httm5PjzsHELBB-P8DmpZ4bGoBR7FH1s6Tmcrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAN05THTOY894httm5PjzsHELBB-P8DmpZ4bGoBR7FH1s6Tmcrg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Dor Laor <dlaor@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christian Borntraeger <borntraeger@de.ibm.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christian Hoff <christian.hoff@de.ibm.com>, borntrae@linux.vnet.ibm.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rusty@rustcorp.com.au, Stefan Hajnoczi <stefanha@gmail.com>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 02/13/2012 02:13 PM, ronnie sahlberg wrote:
> On Tue, Feb 14, 2012 at 12:00 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
>> On Mon, Feb 13, 2012 at 02:54:03PM +0200, Dor Laor wrote:
>>> Only if you use the pci multi-function option but that kills
>>> standard hot unplug
>>
>> It doesn't kill it as such, rather you can't unplug luns individually.
>
> Isnt that just a consequence of the current implementation rather than
> a SCSI limitation?

We're talking about virtio-blk here. :)

Paolo
