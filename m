From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [RFC] Clean up scsi documentation
Date: Sun, 10 Nov 2002 09:49:43 +1100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3DCD9107.3020103@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Rolf Eike Beer <eike@bilbo.math.uni-mannheim.de>
List-Id: linux-scsi@vger.kernel.org

Eike Beer <eike@bilbo.math.uni-mannheim.de> wrote:
 > currently the documentation for scsi is not completely located
 > where it should IMHO be: in Documentation/
 >
 > There are a few files in Documentation and much more files in
 > drivers/scsi/ .
 > I think this should be fixed. Any thougts?
 >
 > My way would be:
 >
 > 1) create a directory Documentation/scsi/
 > 2) move everything to this location
 > 3) rename some of the docs (currently the names look
 > like "README.drivername"
 > but "drivername.txt" is more common in Documentation/*)
 > 4) fix up the references
 > 5) add a 00-INDEX file to Documentation/scsi
<snip/>

Yes, this would be a positive step and has been proposed by
others on the linux-scsi list. It may be a bit late for the
2.4 series but the time would be right for the 2.5 series.

James Bottomley <James.Bottomley@steeleye.com> and Doug Ledford
<dledford@redhat.com> are maintaining BK repositories for the
scsi subsystem in the 2.5 series. If you could submit your
patches to them, then they will find their way to Linus
in an orderly fashion.

Doug Gilbert
