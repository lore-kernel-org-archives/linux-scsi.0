From: "Frank Borich" <Frank_Borich@us.xyratex.com>
Subject: Scsi midlayer question
Date: Fri, 16 Jul 2004 10:55:29 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <47F3C2BE74738E4683574107469DFA204CC4FA@XYUSEX01.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratexus11.xyratex.com ([65.203.33.11]:13555 "EHLO
	XYUSEX01.xyus.xyratex.com") by vger.kernel.org with ESMTP
	id S266560AbUGPRzc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jul 2004 13:55:32 -0400
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I can see from a fibre channel trace that my 1 MB I/O transfers are
getting cut up into little chunks.
Is there any options that can be set when loading the scsi mid layer as
a module that will improve
io performance or prevent this breakdown for the sg,sd, or even raw
drivers.  I am not a driver developer 
so please excuse my ignorance here.   Any info or points in the right
direction would be greatly apprecited.
I am using the 2.4.20 kernel.  
 
Thanks.
 
Franco Borich

Frank Borich
------------------------------------------------------------------
Xyratex Inc.
Systems Engineer
Direct 630 654 6089
Fax 630 325 2513
e-mail frank_borich@us.xyratex.com
 

