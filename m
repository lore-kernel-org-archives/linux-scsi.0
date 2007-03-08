From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Transport ID in Persistent Reservation
Date: Thu, 08 Mar 2007 08:34:50 -0500
Message-ID: <45F010FA.4010001@torque.net>
References: <6bd7946f0703080054u113ffd1aj1f4e2d90c8914a25@mail.gmail.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:52275 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbXCHNgM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Mar 2007 08:36:12 -0500
In-Reply-To: <6bd7946f0703080054u113ffd1aj1f4e2d90c8914a25@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: renuka apte <renuka.apte@gmail.com>
Cc: linux-scsi@vger.kernel.org

renuka apte wrote:
> The 'Specify Initiator Ports' support in persistent reservation allows
> the application client to send a bunch of transport IDs which identify
> initiator ports. I would like to know the suggested format for these
> transport IDs.

http://www.t10.org/ftp/t10/drafts/spc4/spc4r09.pdf
section 7.5.4  "TransportID identifiers"

> I am assuming that it must have something to do with the WWN of the
> initiator ports.

and that is transport dependent.

> I tried using sg_utils to issue a persistent reservation IN command
> with "READ FULL STATUS" to a virtual SCSI disk which is returning the
> response in the format specified in SPC-4. However the sg_utils seems
> to be decoding the transport ID in some way that I cant find in the
> standard.

Have another look :-)

Doug Gilbert



