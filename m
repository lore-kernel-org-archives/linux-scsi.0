From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: aic7xxx sets CDR offline, how to reset?
Date: 04 Sep 2002 00:29:49 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1031095789.21409.49.camel@irongate.swansea.linux.org.uk>
References: <dledford@redhat.com>
	<200209032148.g83LmeP09177@localhost.localdomain>
	<20020903184216.F12201@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20020903184216.F12201@redhat.com>
To: Doug Ledford <dledford@redhat.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2002-09-03 at 23:42, Doug Ledford wrote:
> Not really.  It hasn't been done yet, but one of my goals is to change the 
> scsi commands over to reasonable list usage (finally) so that we can avoid 
> all these horrible linear scans it does now looking for an available 
> command (it also means things like SCSI_OWNER_MID_LAYER can go away 

At least partly done in 2.4-ac and waiting pushing to Marcelo. I believe
Hugh contributed the O(1) command finder
