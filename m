From: Rainer Duffner <rainer@ultra-secure.de>
Subject: Re: fdisk weirdness.
Date: Thu, 25 May 2006 00:50:13 +0200
Message-ID: <4474E325.60809@ultra-secure.de>
References: <5485940d0605241356j1128e38aq1049a9686265547f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <suse-sles-e-return-2519-glss-suse-sles-e=m.gmane.org@suse.com>
List-Post: <mailto:suse-sles-e@<#h>>
List-Help: <mailto:suse-sles-e-help@suse.com>
List-Subscribe: <mailto:suse-sles-e-subscribe@suse.com>
List-Unsubscribe: <mailto:suse-sles-e-unsubscribe-glss-suse-sles-e=m.gmane.org@suse.com>
List-Owner: <mailto:suse-sles-e-owner@suse.com>
In-Reply-To: <5485940d0605241356j1128e38aq1049a9686265547f@mail.gmail.com>
To: C'est Pierre <cestpierre@gmail.com>
Cc: linux-scsi@vger.kernel.org, suse-sles-e@suse.com
List-Id: linux-scsi@vger.kernel.org

C'est Pierre wrote:
> Greetings,
>
> I've been trying to setup a server for a cluster that is attached to a
> fibre channel storage (an HP EVA 3000 hsv100). Prior to allocating a
> vdisk on the storage for this server, whenever I'd issue "fdisk -l",
> it wouldn't print anything at all. After correctly alocating the disk
> on the Storage, it shown 2 disks, sda and sdb. At this point, I assume
> they're 2 LUNS for the same vdisk, being that the Storage attached
> through two different FC cards for redundancy/failover - feel free to
> correct me if I am wrong. However, the /dev/cciss/c0d0[pN] (compaq
> smartarray or something) doesn't show up on it's output.
>
> Any hints?
>
> Thank you,
> Pierre
>
> ---------------------------------------------------------------------
> To unsubscribe, e-mail: suse-sles-e-unsubscribe@suse.com
> For additional commands, e-mail: suse-sles-e-help@suse.com
>




You will probably want to install one of HPs failover-capable drivers:
http://h20000.www2.hp.com/bizsupport/TechSupport/DriverDownload.jsp?pnameOID=315741&locale=en_US&taskId=135&prodSeriesId=315739&prodTypeId=12169&swEnvOID=2026


This is for 2 GBit/s Qlogic-HBA, more or less regardless of the OEM.
(worked for IBM, too, for us).




cheers,
Rainer
