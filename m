From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [LSF/MM TOPIC] end-to-end data and metadata corruption detection
Date: Tue, 17 Jan 2012 15:15:23 -0500
Message-ID: <38C050B3-2AAD-4767-9A25-02C33627E427@oracle.com>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi-

I know there is some work on ext4 regarding metadata corruption detection; btrfs also has some corruption detection facilities.  The IETF NFS working group is considering the addition of corruption detection to the next NFSv4 minor version.  T10 has introduced DIF/DIX.

I'm probably ignorant of the current state of implementation in Linux, but I'm interested in understanding common ground among local file systems, block storage, and network file systems.  Example questions include:  Do we need standardized APIs for block device corruption detection?  How much of T10 DIF/DIX should NFS support?  What are the drivers for this feature (broad use cases)?

-- 
Chuck Lever
chuck[dot]lever[at]oracle[dot]com




--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
