From: Dan Jones <dmjones@ix.netcom.com>
Subject: Re: Wide negotiation fails with 80->68 LVD adapter?
Date: Mon, 21 Oct 2002 22:30:29 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DB4E275.BC760EDE@ix.netcom.com>
References: <200210210514.g9L5ElYp006401@angle.badbox.com> <20021021163424.GE28914@redhat.com> <20021022032435.GA11986@angle.setup.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Alexy Khrabrov <braver@pobox.com>
Cc: linux-scsi@vger.kernel.org

Alexy Khrabrov wrote:
> 
> While I'm on this 80<->68 pins subject, or How to Accomodate
> SCA drives, I wonder what SCA backplane means.  Is it the
> complete SCSI system starting with the controller?  Then it
> has to have 80 pin internal connector?  And Adaptec should
> have it?  But all Adaptec cards, including Ultra320, are
> 68 pin internal/external...  I'm a bit confused.  Is there
> such a thing as 80 pin SCA, PCI SCSI card?  With an 80 pin
> SCA ribbon inside?  Can you guys recommend some good ones?
> Getting a PCI SCSI card is an alternative to getting an
> external enclosure...  Interesting options...
> 

SCA stands for single connnector attachment. It is a super-set
of the 68-pin connector and includes power and ID pins. It was 
designed to allow SCSI drives to be plugged into backplanes. 
There aren't any SCA cables or SCA/PCI cards.

-- 
Dan Jones           "'Tis hard to say, if greater want of skill
                     Appear in writing or in judging ill;
                     But of the two, less dangerous is th' offence 
                     To tire our patience, than mislead our sense." Pope
