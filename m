From: "Parthiban M" <parthi_m@hotmail.com>
Subject: Query reg. free and sysinfo structure !
Date: Fri, 11 Oct 2002 09:47:20 +0530
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <F44WSUOIFLkkPFoffSC00013b73@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-net@vger.kernel.org
Cc: pamanick@npd.hcltech.com
List-Id: linux-scsi@vger.kernel.org

Hello all,

     I've implemented linux kernel modules "for IP storage" using kernel 
socket's and sending/receiving data of size more than one MB. During socket 
operations free command shows 4k leak constantly and after some time it's 
maintaining 2MB in free memory column continuously. pls. let me know any 
memtrace utility available for kernel(2.4.18-3) or solution for my problem.


thanks,
parthi


--
www.hcltechnologies.com

_________________________________________________________________
MSN Photos is the easiest way to share and print your photos: 
http://photos.msn.com/support/worldwide.aspx
