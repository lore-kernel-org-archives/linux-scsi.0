From: Andy Grover <agrover@redhat.com>
Subject: Re: scsi target, likely GPL violation
Date: Thu, 08 Nov 2012 08:57:02 -0800
Message-ID: <509BE45E.6010309@redhat.com>
References: <509A915B.30105@redhat.com> <CAPoiz9wzx_NmuA1ty-U28MGiYr7XKCbDn_e0ZLmz=pNDCqwqFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAPoiz9wzx_NmuA1ty-U28MGiYr7XKCbDn_e0ZLmz=pNDCqwqFw@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Jon Mason <jdmason@kudzu.us>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Marc Fleischmann <mwf@risingtidesystems.com>, Nicholas Bellinger <nab@risingtidesystems.com>
List-Id: linux-scsi@vger.kernel.org

On 11/07/2012 05:02 PM, Jon Mason wrote:
> On Wed, Nov 7, 2012 at 9:50 AM, Andy Grover <agrover@redhat.com> wrote:
>> Your company appears to be shipping kernel features in RTS OS that are
>> not made available under the GPL, specifically support for the
>> EXTENDED_COPY and COMPARE_AND_WRITE SCSI commands, in order to claim
>> full Vmware vSphere 5 VAAI support.
>>
>> http://www.risingtidesystems.com/storage.html
>> http://www.linux-iscsi.org/wiki/VAAI
>>
>> Private emails to you and RTS CEO Marc Fleischmann have not elicited a
>> useful response.
>>
>> You are subsystem maintainer for the in-kernel SCSI target support
>> (drivers/target/*), and your company appears to be violating the GPL.
> 
> The peanut gallery needs more information, as this is quite an
> incendiary claim to be making on a Linux kernel forum.  How are they
> violating the GPL?  I'm not a lawyer, nor do I play one on TV, but if
> I understand the GPL correctly, RTS only needs to provide the relevant
> source to their customers upon request.  Are there customers (perhaps
> Redhat) that they have not provided this to?  If so, then they need to
> be publicly shamed (gpl-violations.org would be a good place to go as
> well).  If not, then they are within their rights to behave the way
> they are currently behaving.
> 
> Again, we need more info before we start flinging the tomatoes at them.

Look at the marketing material on their website. They demonstrate how
RTS OS fully implements vSphere 5 VAAI features. We know to a very high
certainty that this must have been implemented with kernel code, so
therefore this must be a GPL violation, since these changes have not
been made public.

-- Andy
