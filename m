From: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Subject: Re: kernel BUG at drivers/scsi/scsi_lib.c:1096!
Date: Mon, 23 Nov 2015 17:24:33 +0100
Message-ID: <56533DC1.5070505@linux.vnet.ibm.com>
References: <1447838334.1564.2.camel@ellerman.id.au>
 <1447855399.3974.24.camel@redhat.com>
 <1447894964.15206.0.camel@ellerman.id.au>
 <20151119082325.GA11419@infradead.org>
 <1448021448.14769.7.camel@ellerman.id.au>
 <565055C6.5040801@linux.vnet.ibm.com> <20151122005635.1b9ffbe1@tom-T450>
 <1448234410.8209.3.camel@redhat.com> <56531B3F.60503@linux.vnet.ibm.com>
 <20151123151330.GA10990@dhcppc13.redhat.com>
 <56532EC7.3060000@linux.vnet.ibm.com>
 <CACVXFVMNed2Liarx9FA16CERNAepNYdNFhDpn70kb3RBt0eRuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACVXFVMNed2Liarx9FA16CERNAepNYdNFhDpn70kb3RBt0eRuQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>
Cc: Pratyush Anand <panand@redhat.com>, Mark Salter <msalter@redhat.com>, linux-block@vger.kernel.org, Linux SCSI List <linux-scsi@vgneitherer.kernel.org>, "James E. J. Bottomley" <JBottomley@odin.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, brking <brking@us.ibm.com>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

On 23/11/2015 16:27, Ming Lei wrote:
> On Mon, Nov 23, 2015 at 11:20 PM, Laurent Dufour
> <ldufour@linux.vnet.ibm.com> wrote:
>>>
>>> Reverting above commit on top if 4.4-rc1 seems to fix the problem for me.
>>
>> That's what I mentioned earlier ;)
>>
>> Now Ming send an additional patch with seems to fix the bug introduced
>> through the commit bdced438acd8. When testing with this new patch I
>> can't get the panic anymore, but Mark reported he is still hitting it.
> 
> Laurent, thanks for your test on the 1st patch, and looks there are at
> least two problems, and my 2nd patch sent just now should address
> Mark's issue which is caused by bdced438acd83a.
> 
> Once the 2nd one is tested OK, I will send out the two together.

FWIW, I applied the 2nd patch, and my system is still running like a charm.

Cheers,
Laurent.
