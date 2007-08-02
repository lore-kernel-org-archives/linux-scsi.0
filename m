From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Is there any tool can perform a READ Capacity command?
Date: Thu, 02 Aug 2007 12:40:37 -0400
Message-ID: <46B20905.6080203@torque.net>
References: <4104961b0708020730r703557f4gf3df1dd508165a89@mail.gmail.com> <yq13az2uhds.fsf@sermon.lab.mkp.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:59094 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbXHBQkq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Aug 2007 12:40:46 -0400
In-Reply-To: <yq13az2uhds.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jidong xiao <jidong.xiao@gmail.com>, linux-scsi@vger.kernel.org

Martin K. Petersen wrote:
>>>>>> "jidong" == jidong xiao <jidong.xiao@gmail.com> writes:
> 
> jidong> I know sg_modes can help to perform a SCSI MODE SENSE command,
> jidong> is there any tool/command that can perform a READ Capacity
> jidong> command?
> 
> sg_readcap

In the sg3_utils package there is a COVERAGE file which
lists the mapping between SCSI commands and the sg3_utils
utilities that send them. [Amongst other things it is useful
when I forget.]


sg3_utils version 1.25 is work in progress; here is the
ChangeLog to date:

Changelog for sg3_utils-1.25 [20070728]
  - sg_sat_set_features: new utility (actually copied from examples
    directory); renamed examples version: sg__sat_set_features
  - sg_dd: add oflag=sparse to step over bs*bpt number of zeros;
    - with oflag=sparse, write last bs*bpt segment at end or after
      error so file length of OFILE is appropriate
    - when coe>1 then SCSI READ LONG logic remember extended block
      length of first encountered error
  - sg_dd, sgm_dd, sgp_dd: allow iflag=null and oflag=null both of
    which do nothing (placeholders)
  - sg_ses: sync with ses2r17 the r18
  - sg_vpd: add block device characteristics VPD page
  - sg_logs: update background scan results log page, sbc3r11
  - place source in subversion repository
  - convert build logic to use autotools (i.e. './configure ; make')
    - rename this file from CHANGELOG to ChangeLog
    - note: only utilities in main directory built by autotools
      infrastructure; subdirectories still use hand-crafted Makefiles


Doug Gilbert

