From: Kurt Miller <kurt@intricatesoftware.com>
Subject: Re: LSI SAS - SSDs with  DRAT and DZAT
Date: Thu, 17 Apr 2014 18:32:33 -0400
Message-ID: <1397773953.12035.2.camel@sonic.justonedata.com>
References: <1391730975.3449.16.camel@sonic.justonedata.com>
	 <yq1vbwqslek.fsf@sermon.lab.mkp.net>
	 <1391806363.2761.8.camel@sonic.justonedata.com>
	 <yq1mwi2skoz.fsf@sermon.lab.mkp.net>
	 <1391808293.2761.9.camel@sonic.justonedata.com>
	 <yq1iosqs8fx.fsf@sermon.lab.mkp.net>
	 <1391984895.13523.13.camel@tardis.intricatesoftware.com>
	 <1392172050.2761.37.camel@sonic.justonedata.com>
	 <53481EEE.3090405@itwm.fraunhofer.de> <yq1lhv3eoaf.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 4133fa24.cst.lightpath.net ([65.51.250.36]:12242 "EHLO
	mail1.intricatesoftware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750928AbaDQWix (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Apr 2014 18:38:53 -0400
In-Reply-To: <yq1lhv3eoaf.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>, linux-scsi@vger.kernel.org

On Thu, 2014-04-17 at 15:42 -0400, Martin K. Petersen wrote:
> >>>>> "Bernd" == Bernd Schubert <bernd.schubert@itwm.fraunhofer.de> writes:
> 
> Bernd> Any other suggestions for ~240GB SSDs supporting DRAT and DZAT or
> Bernd> trim-on-lsi-sas in general?
> 
> intel drives (other than the 510 which was a one-off) are generally
> very well-behaved.
> 

Both Intel S3500 Series and Samsung 840 Pro SSDs with LSI in IT mode are
working well in my development lab here, including TRIM support.

-Kurt

