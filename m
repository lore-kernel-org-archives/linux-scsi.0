From: Douglas Gilbert <dougg@torque.net>
Subject: Re: lsscsi-0.17 released
Date: Wed, 22 Feb 2006 12:59:34 -0500
Message-ID: <43FCA686.5020508@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:39854 "EHLO
	tomts25-srv.bellnexxia.net") by vger.kernel.org with ESMTP
	id S1422647AbWBVSAd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 13:00:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Greg KH wrote:
>>/sys/class/scsi_device/<hcil>/device/block symlink
>>changed to ".../block:sd<x>" breaking lsscsi 0.16 (and
>>earlier) and sg_map26 (in sg3_utils).

> It was changed as there would be more than one "block" symlink in a
> device's directory if more than one block device was attached to a
> single struct device.  For example, ub and multi-lun devices (there were
> other reports of this happening for scsi devices too at the time from
> what I remember.)

A "scsi_device" is a logical unit, hence the "l" at
the end of the "<hcil>" acronym in the above path.
So it wasn't broken. However there is some fuzziness
in this area, for example the term "scsi_device".

Doug Gilbert
