From: Stephen Cameron <steve.cameron@compaq.com>
Subject: Re: compaq smart array 5i raid controller
Date: Mon, 22 Apr 2002 08:08:43 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020422080843.A9129@zuul.cca.cpqcorp.net>
Reply-To: steve.cameron@compaq.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: radu.alexa@mobilcom.de
Cc: linux-scsi@vger.kernel.org

radu.alexa@mobilcom.de wrote:
> I have a compaq dl380g2 server with a smart array 5i raid controller and 
> a dat dds4 scsi tape drive attached to it. distribution suse7.3, kernel 
> 2.4.16 from suse. I'm using the cciss driver but I can't access the tape 
> drive - it is not recognized.
> in documenation/cciss.txt of kernel 2.4.18 it is written:

Yes.  For some reason, perhaps by accident, Linus accepted the 
documentation portion of the tape support patch to the cciss
driver much before accepting the code with implemented what the
documentation described.  So for a period, the documentation
claimed tape drives were supported when actually, they were not.

(a version of) the cciss tape support code got accepted into 
2.4.19-pre1, if I recall correctly.

Hope that explains things.

(sorry for the late response, I don't read linux-scsi much lately.)

-- steve

