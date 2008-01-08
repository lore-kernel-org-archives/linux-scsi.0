From: "Chris Friesen" <cfriesen@nortel.com>
Subject: looking for help with mpt fusion driver log:  "FAULT code = 1804h"
Date: Tue, 08 Jan 2008 12:00:06 -0600
Message-ID: <4783BA26.1090304@nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755237AbYAHSAb@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Hi all,

We're seeing the following on startup:

Fusion MPT base driver 3.02.55
Copyright (c) 1999-2005 LSI Logic Corporation
Fusion MPT SAS Host driver 3.02.55
mptbase: Initiating ioc0 bringup
mptbase: ioc0: WARNING - IOC is in FAULT state!!!
            FAULT code = 1804h
mptbase: ioc0: ERROR - Failed to come READY after reset! IocState=0
mptbase: ioc0 NOT READY WARNING!
mptbase: WARNING - ioc0 did not initialize properly! (-1)
mptsas: probe of 0000:05:01.0 failed with error -1


Is this a disk fault or a host fault?  Can anyone identify what the 
specific fault code means, or point me to a suitable resource?

Thanks,

Chris
