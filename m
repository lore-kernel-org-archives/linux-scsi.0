From: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Subject: RE: [PATCH 2.6.12-rc4-mm1 3/4] megaraid_sas: updating the driver
Date: Tue, 17 May 2005 18:13:49 -0400
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57060CCE96@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262024AbVEQWQ7@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>, Arjan van de Ven <arjan@infradead.org>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'Matt_Domsch@Dell.com'" <Matt_Domsch@Dell.com>, Andrew Morton <akpm@osdl.org>, 'Christoph Hellwig' <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

>
>On Mon, 2005-05-16 at 10:06 +0200, Arjan van de Ven wrote:
>> > +			spin_lock( instance->host_lock );
>> > +			cmd->scmd->scsi_done( cmd->scmd );
>> > +			spin_unlock( instance->host_lock );
>> 
>> are you really sure you don't want to use spin_lock_irqsave() here ?
>
>Actually, don't bother with the lock at all.  scsi_done() is 
>designed to
>be called locklessly.
>
>James

Okay. I will remove that.

Thanks,
Sreenivas
