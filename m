From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Adaptec 7901A-iROC - aic79xx
Date: Fri, 26 Sep 2003 10:54:43 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <690660000.1064595283@aslan.btc.adaptec.com>
References: <3F73E601.5060300@netcore.co.in>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([216.52.22.10]:43203 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S261468AbTIZQvO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2003 12:51:14 -0400
In-Reply-To: <3F73E601.5060300@netcore.co.in>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Rajesh <rajeshsg@netcore.co.in>, linux-scsi@vger.kernel.org

> Hi List,
> 
> 
>      I am having on-board Adaptec 7901-iROC (SCSI Raid Controller).  I am
> not able to get it working even with latest 2.4.22 kernel. Kernel 2.4.22
> seems to have latest source from http://people.freebsd.org/~gibbs/linux/
> of the driver. Is this controller supported by aic79xx???  Or else i have
> to try something else???

Disable HostRAID via SCSI-Select.  The aic79xx driver does not support
HostRAID.

--
Justin

