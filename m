From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: aic7xxx sets CDR offline, how to reset?
Date: 04 Sep 2002 00:26:45 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1031095605.21579.44.camel@irongate.swansea.linux.org.uk>
References: <200209032202.g83M2mC09323@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200209032202.g83M2mC09323@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 2002-09-03 at 23:02, James Bottomley wrote:
> > And what happens if one command gets some sort of check condition
> > (like medium error, or aborted command) that causes a retry? Will IO's
> > still be correctly ordered? 
> 
> Retries get eliminated.  It should be up to the upper layers (sd or beyond) to 
> say whether a retry is done.  Since, as you point out, retries automatically 
> violate any barrier, it is probably up to the block layer to judge what should 
> be done about the problem.

Then we need to give the block layer a lot more information about what
kind of a problem occurred

