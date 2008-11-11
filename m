From: jim owens <jowens@hp.com>
Subject: Re: Thin provisioning & arrays
Date: Tue, 11 Nov 2008 11:53:16 -0500
Message-ID: <4919B87C.8030100@hp.com>
References: <28572.1226369378@ocs10w> <49198FC3.7080301@redhat.com> <49199CFF.8080002@hp.com> <4919A705.2070301@redhat.com> <4919ABC6.8030606@hp.com> <4919B1DD.3030207@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4919B1DD.3030207@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Keith Owens <kaos@ocs.com.au>, Black_David@emc.com, david@fromorbit.com, dwmw2@infradead.org, martin.petersen@oracle.com, chris.mason@oracle.com, jens.axboe@oracle.com, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, coughlan@redhat.com, matthew@wil.cx
List-Id: linux-scsi@vger.kernel.org

Ric Wheeler wrote:
> 
> I think that the concern is that the exact implementation is actually 
> already coded and relatively easy for us to do (i.e., send down unmap 
> commands at natural file system level units after a truncate/delete).
> 
> The irony is that the hard part is to try to approach that level of 
> exactness with the other techniques (coalescing unmaps, defrag, etc) :-)

I was using "exact" in the second sense... our battle about
matching exactly with an array where the thin unmap chunk is
greater than the natural file system level unit.

Saying in that case, extreme measures are not justified.

jim
