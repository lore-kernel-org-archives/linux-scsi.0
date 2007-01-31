From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] - export scsilun_to_int
Date: Wed, 31 Jan 2007 11:01:51 -0600
Message-ID: <1170262911.3402.46.camel@mulgrave.il.steeleye.com>
References: <20070129164022.GA1867@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:47673 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932978AbXAaRBz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Jan 2007 12:01:55 -0500
In-Reply-To: <20070129164022.GA1867@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsi.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2007-01-29 at 09:40 -0700, Eric Moore wrote:
> export symbol to be used in 1st fusion patch
> 
> Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

This is wrong.  the "int" represents our internal coding of the 8 byte
extended LUN (currently it's a lossy transform that only allows up to
two level LUNs, so one day this will definitely change).  No driver
should be using this internally.  From the patches it merely looks like
you want to print out the value of a struct scsilun in debugging code,
so perhaps a simple print_scsilun or something would be better?

James


