From: "Smarduch Mario-CMS063" <CMS063@motorola.com>
Subject: RE: SCSI device recover
Date: Tue, 11 Sep 2007 14:28:00 -0400
Message-ID: <2D25C6D9C1440E4E8228FC62AE28649802371B03@de01exm69.ds.mot.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail153.messagelabs.com ([216.82.253.51]:55298 "HELO
	mail153.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760922AbXIKS2G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2007 14:28:06 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-newbie@vger.kernel.org, linux-scsi@vger.kernel.org

Hi,
 
We're seeing an issue where a SCSI device failure freezes the system
and it takes about 13s for the system to recover. Not knowing enough
about SCSI or how SCSI works on Linux I have a couple questions.
 
- is there a way to configure the recovery timeouts such as aborts
  and resets?
 
- if yes to what values (ms, seconds) can these be changed?
 
BR,
  mjs.
