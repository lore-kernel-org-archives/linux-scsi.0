From: "Isabelle, Francois" <Francois.Isabelle@ca.kontron.com>
Subject: Sym53C8xx Driver Hardening
Date: Tue, 23 Jul 2002 09:29:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <5009AD9521A8D41198EE00805F85F18F219A7C@sembo111.teknor.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: "Linux SCSI list (E-mail)" <linux-scsi@vger.kernel.org>

Hi, 
    anyone working on driver hardening such as defined by the TLT/CGL
specification ?

TLT : Telecom Linux Technology
CGL: Open Source Development Lab - Carrier Grade Linux

Theese are 2 projects to define a "highly available" and "easily embeddable"
linux for the replacement of proprietary telecom platform.
The specification includes a section related to "driver hardening"

Some of the features:
 - Panic removal
 - Standardized event logging
 - Parameter checking ...

The white paper from Intel:
http://cedar.intel.com/cgi-bin/ids.dll/content/content.jsp?cntKey=Generic%20
Editorial::linux_hardening&cntType=IDS_EDITORIAL&catCode=0

Here is a quote from A.C. on the linux-ha list:
What I've seen so far on the hardening proposals varies between the
comical and the well-intentioned but ugly intel code. I've not seen
public montavista work so it would inappropriate for me to comment on it.

As you see, it's not really accepted at unanimity ...
It's just not bazaar like enough I suppose !

Anyway there is some good in such standardization and if it produces better
drivers for linux, why not ?

So to get back to the topic :
	anyone started sym53c8xx driver hardening ?

It might already be full proof but most certainly lacks standard event
logging.

Any comments on CGL/TLT appreciated
Thank you

Francois Isabelle
Kontron Canada Inc.

